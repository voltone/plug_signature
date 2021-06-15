defmodule PlugSignature do
  @moduledoc """
  Server side implementation of IETF HTTP signature draft
  (https://tools.ietf.org/html/draft-cavage-http-signatures-11), as a reusable
  Plug.

  Supports the following algorithms:

  * "hs2019", using ECDSA, RSASSA-PSS or HMAC (all with SHA-512)
  * "rsa-sha256", using RSASSA-PKCS1-v1_5
  * "ecdsa-sha256"
  * "hmac-sha256"
  * "rsa-sha1", using RSASSA-PKCS1-v1_5

  ECDSA signatures with hs2019/ecdsa-sha256 are accepted in ASN.1 or raw
  r/s format, for maximum interoperability.

  ## Signature validity time window

  Requests signed according to the "hs2019" algorithm should include a
  'created' and/or 'expires' timestamp. When present in the Authorization
  header, the 'created' parameter is checked against the configured validity
  (unless it is set to `:infinity`) and the 'expires' parameter is checked
  against the current time.

  At least one of these parameters should be included in the signature
  calculation, through the respecive pseudo-header. The validity check based
  on 'created' and/or 'expires' takes place regardless of whether the
  parameters were signed.

  For legacy algorithms, signature validity should be checked using the HTTP
  'Date' header. This happens for all algorithms (including "hs2019") if and
  only if when the header value is included in the signature.

  ## Signing the request body

  The HTTP 'Digest' header can be used to protect the integrity of the request
  body and include it in the signature.  The `PlugSignature` Plug treats the
  'Digest' header as any other header, i.e. it verifies the integrity of the
  header value if included in the signature, but it does not verify the
  integrity of the request body itself.

  Use a Plug such as [PlugBodyDigest](https://hex.pm/packages/plug_body_digest)
  to handle the processing of the 'Digest' header.

  ## Options

  * `:callback_module` (mandatory) - the name of a callback module implementing
    the `PlugSignature.Callback` behaviour; this module must implement the
    `c:PlugSignature.Callback.client_lookup/3` callback
  * `:algorithms` - the signature algorithms, as defined in the IETF
    specification; a list containing one or more of:

     * `"hs2019"` (default)

    Legacy algorithms:

     * `"rsa-sha256"`
     * `"rsa-sha1"`
     * `"ecdsa-sha256"`
     * `"hmac-sha256"`

    The first algorithm in the list is considered the default algorithm: if a
    client does not specify an algorithm the request is assumed to be signed
    using this algorithm
  * `:headers` - the minimum set of (pseudo-)headers that need to be signed;
    defaults to the request timestamp, taken from the 'created' signature
    parameter or the HTTP 'Date' header, depending on the selected algorithm
  * `:validity` - a `Range` defining the timeframe (in seconds) after
    signing during which the signature is considered valid; set to
    `:infinity` to disable, relying solely on the `:expires` parameter;
    defaults to `-300..30`, meaning a signature can be up to 5 minutes old, or
    up to 30 seconds in the future
  * `:legacy` - a keyword list, used to override the `:headers` and/or
    `:validity` options for legacy algorithms (those other than "hs2019");
    this may be necessary when these options are set to values not supported
    by the legacy algorithms; see the examples below
  * `:on_success` - an optional callback for updating the `Plug.Conn` state
    upon success; possible values include:

    * `nil` (the default) - do nothing
    * `{PlugSignature, :assign_client, [key]}` - assign the client, as
      returned by the `c:PlugSignature.Callback.client_lookup/3` callback,
      in the `Plug.Conn` struct to the specified key
    * `{m, f, a}` - call the function identified by the atom `f` in module
      `m`; the function receives the current `Plug.Conn` struct and the
      `client` returned by the `c:PlugSignature.Callbacks.client_lookup/3`
      callback, along with any additional parameters in the list `a`, and is
      expected to return the updated `Plug.Conn` struct

  * `:on_failure` - an optional callback for updating the `Plug.Conn` state
    upon failure; possible values include:

    * `{PlugSignature, :failure, []}` (the default) - halt the connection
      with an appropriate response; see `failure/3` below
    * `{m, f, a}` - call the function identified by the atom `f` in module
      `m`; the function receives the current `Plug.Conn` struct, the error
      reason,the selected algorithm (a string) and a list of required headers
      (strings, for possible use in a 'WWW-Authenticate' response header),
      along with any additional parameters in the list `a`; it is expected to
      return the updated `Plug.Conn` struct; see the implementation of
      `failure/4` for an example
    * `nil` - do nothing

  ## Examples

      # Minimal example relying on defaults: "hs2019" algorithm only, with
      # minimal "(created)" headers and default validity:
      plug PlugSignature, callback_module: MyApp.SignatureAuth

      # More realistic example with custom header configuration; "hs2019"
      # only:
      plug PlugSignature,
        callback_module: MyApp.SignatureAuth,
        headers: "(request-target) (created) host digest"

      # Using legacy algorithms only, with custom header set:
      plug PlugSignature,
        callback_module: MyApp.SignatureAuth,
        algorithms: ["ecdsa-sha256", "rsa-sha256"],
        headers: "(request-target) date host"

      # Mix of "hs2019" and legacy algorithms, using 'expires' rather than
      # 'created' to verify validity for "hs2019"; the `:legacy` option is
      # necessary since the `:headers` and `:validity` values are not valid
      # for legacy algoritms:
      plug PlugSignature,
        callback_module: MyApp.SignatureAuth,
        headers: "(request-target) (expires) host digest",
        validity: :infinity,
        legacy: [
          headers: "(request-target) date host digest",
          validity: -300..30,
        ]

  """

  import Plug.Conn
  require Logger
  alias PlugSignature.Config
  alias PlugSignature.SignatureString
  alias PlugSignature.Crypto

  @behaviour Plug

  @impl true
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts) do
    Config.new(opts)
  end

  @impl true
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    algorithms = Keyword.fetch!(opts, :algorithms)
    default_algorithm = Keyword.fetch!(opts, :default_algorithm)

    # Parse Authorization header and select algorithm
    with {:ok, authorization} <- get_authorization_header(conn),
         {:ok, signature_opts} <- PlugSignature.Parser.authorization(authorization),
         {:ok, algorithm, algorithm_opts} <-
           select_algorithm(signature_opts, default_algorithm, algorithms) do
      # Ready to call main verification function
      verify(conn, algorithm, algorithm_opts, signature_opts, opts)
    else
      {:error, reason} ->
        headers = algorithms[default_algorithm].headers
        on_failure(opts[:on_failure], conn, reason, default_algorithm, headers)
    end
  end

  defp get_authorization_header(conn) do
    case get_req_header(conn, "authorization") do
      [authorization | _] -> {:ok, authorization}
      _otherwise -> {:error, "no authorization header"}
    end
  end

  defp select_algorithm(signature_opts, default_algorithm, algorithms) do
    algorithm = Keyword.get(signature_opts, :algorithm, default_algorithm)

    case algorithms[algorithm] do
      nil ->
        {:error, "bad signing algorithm #{algorithm}"}

      algorithm_opts ->
        {:ok, algorithm, algorithm_opts}
    end
  end

  defp verify(conn, algorithm, algorithm_opts, signature_opts, opts) do
    with {:ok, header_list, signature} <- handle_signature_opts(signature_opts, algorithm_opts),
         # Check validity based on timestamp and/or date header
         :ok <- verify_signature_timestamp(signature_opts, algorithm_opts.validity),
         :ok <- verify_signature_expiry(signature_opts),
         :ok <-
           verify_date_header(conn, algorithm_opts.validity, algorithm_opts.check_date_header),
         # Look up client and credentials
         key_id = Keyword.get(signature_opts, :key_id),
         {:ok, client, credentials} <-
           opts[:callback_module].client_lookup(key_id, algorithm, conn),
         # Build string to sign based on headers and algorithm
         {:ok, signature_string} <-
           SignatureString.build(conn, signature_opts, algorithm, header_list),
         # Verify the signature
         {:ok, true} <- Crypto.verify(signature_string, algorithm, signature, credentials) do
      # All checks passed: continue
      on_success(opts[:on_success], conn, client)
    else
      {:ok, false} ->
        reason = "incorrect signature or HMAC"
        on_failure(opts[:on_failure], conn, reason, algorithm, algorithm_opts.headers)

      {:error, reason} ->
        on_failure(opts[:on_failure], conn, reason, algorithm, algorithm_opts.headers)
    end
  end

  defp handle_signature_opts(signature_opts, algorithm_opts) do
    # - keyId is mandatory, though we do not need it here
    # - signature is mandatory
    # - headers is optional, at least the expected headers must be present
    with {:ok, _key_id} <- fetch(signature_opts, :key_id),
         {:ok, signature_b64} <- fetch(signature_opts, :signature),
         {:ok, signature} <- decode64(signature_b64) do
      headers = Keyword.get(signature_opts, :headers, algorithm_opts.default_headers)
      header_list = headers |> String.downcase() |> String.split(" ", trim: true)

      case algorithm_opts.header_list -- header_list do
        [] ->
          {:ok, header_list, signature}

        missing_headers ->
          {:error, "insufficient signature coverage: #{Enum.join(missing_headers, ", ")}"}
      end
    end
  end

  defp fetch(keyword_list, key) do
    case Keyword.fetch(keyword_list, key) do
      :error -> {:error, "key #{key} not found"}
      success -> success
    end
  end

  defp decode64(b64) do
    case Base.decode64(b64) do
      :error -> {:error, "Base64 decoding failed"}
      success -> success
    end
  end

  def verify_signature_timestamp(signature_opts, validity \\ -300..30) do
    with {:ok, created} <- Keyword.fetch(signature_opts, :created),
         {:parse, {unix_int, ""}} <- {:parse, Integer.parse(created)} do
      unix_int
      |> DateTime.from_unix!()
      |> verify_validity(validity)
    else
      :error ->
        # Missing 'created' parameter, cannot verify validity
        :ok

      _error ->
        {:error, "malformed signature creation timestamp"}
    end
  end

  def verify_signature_expiry(signature_opts) do
    with {:ok, expires_str} <- Keyword.fetch(signature_opts, :expires),
         {:parse, {expires, ""}} <- {:parse, Integer.parse(expires_str)} do
      now = DateTime.utc_now() |> DateTime.to_unix()

      if now > expires do
        {:error, "request expired"}
      else
        :ok
      end
    else
      :error ->
        # Missing 'expires' parameter, cannot verify validity
        :ok

      _error ->
        {:error, "malformed signature expiry timestamp"}
    end
  end

  defp verify_date_header(_conn, _validity, false), do: :ok
  defp verify_date_header(_conn, :infinity, true), do: :ok

  defp verify_date_header(conn, validity, true) do
    case get_req_header(conn, "date") do
      [date] ->
        date
        |> :plug_signature_http_date.parse_date()
        |> NaiveDateTime.from_erl!()
        |> DateTime.from_naive!("Etc/UTC")
        |> verify_validity(validity)

      _otherwise ->
        {:error, "missing Date header"}
    end
  end

  defp verify_validity(_date_time, :infinity), do: :ok

  defp verify_validity(date_time, past..future) do
    age = DateTime.diff(date_time, DateTime.utc_now())

    cond do
      age < past -> {:error, "request expired"}
      age > future -> {:error, "request timestamp in the future"}
      true -> :ok
    end
  end

  defp on_success(nil, conn, _client), do: conn
  defp on_success({m, f, a}, conn, client), do: apply(m, f, [conn, client | a])
  defp on_success(fun, conn, client) when is_function(fun, 2), do: fun.(conn, client)
  defp on_success(fun, conn, _client) when is_function(fun, 1), do: fun.(conn)

  defp on_failure(nil, conn, _reason, _algorithm, _headers), do: conn

  defp on_failure({m, f, a}, conn, reason, algorithm, headers),
    do: apply(m, f, [conn, reason, algorithm, headers | a])

  defp on_failure(fun, conn, reason, algorithm, headers) when is_function(fun, 4),
    do: fun.(conn, reason, algorithm, headers)

  defp on_failure(fun, conn, reason, algorithm, _headers) when is_function(fun, 3),
    do: fun.(conn, reason, algorithm)

  defp on_failure(fun, conn, reason, _algorithm, _headers) when is_function(fun, 2),
    do: fun.(conn, reason)

  @doc """
  Success function that assigns the authenticated client under the specified
  key in the `Plug.Conn` struct.
  """
  @spec assign_client(Plug.Conn.t(), any(), atom()) :: Plug.Conn.t()
  def assign_client(conn, client, field_name) do
    assign(conn, field_name, client)
  end

  @doc """
  The default failure function.

  It logs the failure reason, returns a 401 'Unauthorized' response with a
  'WWW-Authenticate' response header listing the supported algorithms, and
  halts the connection.
  """
  @spec failure(Plug.Conn.t(), String.t(), String.t(), String.t()) :: Plug.Conn.t()
  def failure(conn, reason, algorithm, headers) do
    Logger.info("Request unauthorized: #{reason}")

    # We do not expose the exact reason to the client, just a generic 401, to
    # avoid leaking information that may help an attacker
    conn
    |> put_resp_header(
      "www-authenticate",
      ~s(Signature algorithm=#{algorithm},headers="#{headers}")
    )
    |> send_resp(401, "")
    |> halt()
  end
end
