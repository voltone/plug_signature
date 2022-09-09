defmodule PlugSignature.ConnTest do
  @moduledoc """
  Helpers for testing HTTP signatures with Plug/Phoenix.
  """

  import Plug.Conn

  alias PlugSignature.Crypto

  # This module injects the signature calculation right before invoking the
  # Phoenix Endpoint. This allows us to reuse Phoenix.ConnTest helpers for
  # building the Plug.Conn struct, and add the signature once all the conn
  # parameters have been initialized.
  defmodule EndpointWrapper do
    @moduledoc false

    def init(args), do: args

    def call(%Plug.Conn{private: %{PlugSignature.ConnTest => sign_opts}} = conn, args) do
      endpoint = Keyword.fetch!(sign_opts, :endpoint)

      conn
      |> PlugSignature.ConnTest.with_signature(sign_opts[:key], sign_opts[:key_id], sign_opts)
      |> endpoint.call(args)
    end
  end

  @doc """
  Adds an Authorization header with a signature. Requires a secret (RSA
  private key, EC private key or HMAC shared secret) and key ID.

  ## Options

    * `:algorithms` - the HTTP signature algorithms to be used; list with
      one or more of:

        * `"hs2019"` (default)
        * `"rsa-sha256"`
        * `"rsa-sha1"`
        * `"ecdsa-sha256"`
        * `"hmac-sha256"`

      The first algorithm in the list will be used to generate the signature
      (it is a list to allow the core set of configuration options to be
      shared with `PlugSignature` in tests).
    * `:headers` - set the list of HTTP (pseudo) headers to sign; defaults to
      "(created)" (which is only valid when the algorithm is "hs2019")
    * `:request_target` - explicitly set the request target; by default it is
      built from the Plug.Conn struct (method, request_path and query)
    * `:age` - shift the HTTP Date header and the signature's 'created'
      parameter by the given number of seconds into the past; defaults to 0
    * `:created` - set the signature's 'created' parameter (overrides `:age`);
      set to a empty string to omit the 'created' parameter
    * `:date` - set the HTTP Date header (overrides `:age`)
    * `:expires_in` - if set, adds an 'expires' parameter with a timestamp
      the given number of seconds in the future
    * `:expires` - set the signature's 'expires' parameter (overrides
       `:expires_in`)
    * `:key_id_override` - override the value for `keyId` in the Authorization
      header
    * `:algorithm_override` - override the value for the signature's
      'algorithm' parameter in the Authorization header
    * `:signature_override` - override the signature value sent in the
      Authorization header
    * `:headers_override` - override the value for the signature's 'headers'
      parameter in the Authorization header
    * `:created_override` - override the value for the signature's 'created'
      parameter in the Authorization header
    * `:expires_override` - override the value for the signature's 'expires'
      parameter in the Authorization header
  """
  def with_signature(conn, key, key_id, opts \\ []) do
    age = Keyword.get(opts, :age, 0)
    created = Keyword.get_lazy(opts, :created, fn -> created(age) end)
    date = Keyword.get_lazy(opts, :date, fn -> http_date(age) end)
    expires_in = Keyword.get(opts, :expires_in, nil)
    expires = Keyword.get_lazy(opts, :expires, fn -> expires(expires_in) end)
    algorithms = Keyword.get(opts, :algorithms, ["hs2019"])
    algorithm = hd(algorithms)
    headers = Keyword.get(opts, :headers, default_headers(algorithm))
    header_name = Keyword.get(opts, :header_name, "authorization")

    conn =
      conn
      |> maybe_add_host_header()
      |> put_req_header("date", date)

    request_target =
      Keyword.get_lazy(opts, :request_target, fn ->
        method = conn.method |> to_string |> String.downcase()

        case conn.query_string do
          "" ->
            "#{method} #{conn.request_path}"

          query ->
            "#{method} #{conn.request_path}?#{query}"
        end
      end)

    to_be_signed =
      Keyword.get_lazy(opts, :to_be_signed, fn ->
        headers
        |> String.split(" ")
        |> Enum.map(fn
          "(request-target)" -> "(request-target): #{request_target}"
          "(created)" -> "(created): #{created}"
          "(expires)" -> "(expires): #{expires}"
          "date" -> "date: #{date}"
          header -> "#{header}: #{get_req_header(conn, header) |> Enum.join(",")}"
        end)
        |> Enum.join("\n")
      end)

    signature =
      Keyword.get_lazy(opts, :signature, fn ->
        {:ok, signature} = Crypto.sign(to_be_signed, algorithm, key)
        Base.encode64(signature)
      end)

    signature_string =
      [
        ~s(keyId="#{Keyword.get(opts, :key_id_override, key_id)}"),
        ~s(signature="#{Keyword.get(opts, :signature_override, signature)}"),
        ~s(headers="#{Keyword.get(opts, :headers_override, headers)}"),
        ~s(created=#{Keyword.get(opts, :created_override, created)}),
        ~s(expires=#{Keyword.get(opts, :expires_override, expires)}),
        ~s(algorithm=#{Keyword.get(opts, :algorithm_override, algorithm)})
      ]
      |> Enum.reject(&Regex.match?(~r/^[^=]+=("")?$/, &1))
      |> Enum.join(",")

    case header_name do
      "authorization" ->
        put_req_header(conn, "authorization", "Signature #{signature_string}")

      _ ->
        put_req_header(conn, header_name, signature_string)
    end
  end

  defp default_headers("hs2019"), do: "(created)"
  defp default_headers(_legacy), do: "date"

  @doc """
  Add an HTTP Digest header (RFC3230, section 4.3.2).

  When the request body is passed in as a binary, a SHA-256 digest of the body
  is calculated and added as part of the header. Alternatively, a map of
  digest types and values may be provided.
  """
  @deprecated "Use PlugBodyDigest.ConnTest.with_digest/2, from the plug_body_digest package"
  def with_digest(conn, body_or_digests)

  def with_digest(conn, digests) when is_map(digests) do
    digest_header =
      digests
      |> Enum.map(fn {alg, value} -> "#{alg}=#{value}" end)
      |> Enum.join(",")

    put_req_header(conn, "digest", digest_header)
  end

  def with_digest(conn, body) do
    with_digest(conn, %{"SHA-256" => :crypto.hash(:sha256, body) |> Base.encode64()})
  end

  @http_methods [:get, :post, :put, :patch, :delete, :options, :connect, :trace, :head]

  for method <- @http_methods do
    function = :"signed_#{method}"

    @doc """
    Makes a signed request to a Phoenix endpoint.

    The last argument is a keyword list with signature options, with the
    `:key` and `:key_id` options being mandatory. For other options, please
    see `with_signature/4`.

    Requires Phoenix.ConnTest.
    """
    defmacro unquote(function)(conn, path, params_or_body \\ nil, sign_opts) do
      raise_on_missing_phoenix_conntest!()

      method = unquote(method)

      quote bind_quoted: [
              conn: conn,
              method: method,
              path: path,
              params_or_body: params_or_body,
              sign_opts: sign_opts
            ] do
        conn
        |> put_private(PlugSignature.ConnTest, [{:endpoint, @endpoint} | sign_opts])
        |> Phoenix.ConnTest.dispatch(
          PlugSignature.ConnTest.EndpointWrapper,
          method,
          path,
          params_or_body
        )
      end
    end
  end

  defp created(nil), do: ""

  defp created(age) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    to_string(now - age)
  end

  defp http_date(age) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(0 - age)
    |> NaiveDateTime.to_erl()
    |> :plug_signature_http_date.rfc7231()
  end

  defp expires(nil), do: ""

  defp expires(validity) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    to_string(now + validity)
  end

  defp maybe_add_host_header(%Plug.Conn{host: host} = conn) when is_binary(host) do
    case get_req_header(conn, "host") do
      [] ->
        put_req_header(conn, "host", host)

      _ ->
        conn
    end
  end

  defp maybe_add_host_header(conn), do: conn

  defp raise_on_missing_phoenix_conntest! do
    Code.ensure_loaded?(Phoenix.ConnTest) ||
      raise "endpoint testing requirs Phoenix.ConnTest"
  end
end
