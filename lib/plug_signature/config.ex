defmodule PlugSignature.ConfigError do
  @moduledoc """
  Exception raised in case of an invalid configuration.
  """

  defexception [:message]
end

defmodule PlugSignature.Config do
  @moduledoc false

  @default_algorithms ["hs2019"]
  @hs2019_default_headers "(created)"
  @legacy_default_headers "date"
  @default_validity -300..30
  @default_on_success nil
  @default_on_failure {PlugSignature, :failure, []}

  @legacy_algorithms ["rsa-sha1", "rsa-sha256", "hmac-sha256", "ecdsa-sha256"]

  @type on_success ::
          nil
          | {module(), atom(), [term()]}
          | (Plug.Conn.t(), term() -> Plug.Conn.t())
          | (Plug.Conn.t() -> Plug.Conn.t())
  @type on_failure ::
          nil
          | {module(), atom(), [term()]}
          | (Plug.Conn.t(), String.t(), String.t(), [String.t()] -> Plug.Conn.t())
          | (Plug.Conn.t(), String.t(), String.t() -> Plug.Conn.t())
          | (Plug.Conn.t(), String.t() -> Plug.Conn.t())

  # Used to validate the `PlugSignature` configuration; since the arguments to
  # the `PlugSignature.init/1` are typically evaluated at compile-time, this
  # can help catch configuration issues early
  @spec new(Keyword.t()) :: [
          {:callback_module, Module.t()}
          | {:default_algorithm, String.t()}
          | {:algorithms, map()}
          | {:on_success, on_success()}
          | {:on_failure, on_failure()}
        ]
  def new(opts) do
    callback_module =
      Keyword.get(opts, :callback_module) ||
        raise PlugSignature.ConfigError, "missing mandatory option `:callback_module`"

    algorithms = Keyword.get(opts, :algorithms, @default_algorithms)

    if algorithms == [] do
      raise PlugSignature.ConfigError, "algorithm list is empty"
    end

    on_success = opts |> Keyword.get(:on_success, @default_on_success) |> validate_on_success()
    on_failure = opts |> Keyword.get(:on_failure, @default_on_failure) |> validate_on_failure()

    algorithm_config =
      algorithms
      |> Enum.map(&{&1, opts_for_algorithm(&1, opts)})
      |> Enum.into(%{})

    [
      callback_module: callback_module,
      default_algorithm: hd(algorithms),
      algorithms: algorithm_config,
      on_success: on_success,
      on_failure: on_failure
    ]
  end

  # Expand and validate options per algorithm; raise on unknown algorithm or
  # invalid configuration

  defp opts_for_algorithm("hs2019", opts) do
    headers = Keyword.get(opts, :headers, @hs2019_default_headers)
    header_list = headers |> String.downcase() |> String.split(" ", trim: true)
    validate_header_list!(header_list, "hs2019")
    validity = Keyword.get(opts, :validity, @default_validity)

    case validity do
      :infinity ->
        if "(expires)" not in header_list do
          raise PlugSignature.ConfigError, "missing pseudo-header `(expires)` in header list"
        end

      _from.._to ->
        :ok

      _otherwise ->
        raise PlugSignature.ConfigError, "validity must be a range, or `:infinity`"
    end

    %{
      headers: headers,
      header_list: header_list,
      default_headers: @hs2019_default_headers,
      validity: validity,
      check_date_header: "date" in header_list
    }
  end

  defp opts_for_algorithm(algorithm, opts) when algorithm in @legacy_algorithms do
    legacy_opts = Keyword.get(opts, :legacy, [])

    headers =
      Keyword.get(legacy_opts, :headers, Keyword.get(opts, :headers, @legacy_default_headers))

    header_list = headers |> String.downcase() |> String.split(" ", trim: true)
    validate_header_list!(header_list, algorithm)

    validity =
      Keyword.get(legacy_opts, :validity, Keyword.get(opts, :validity, @default_validity))

    case validity do
      :infinity ->
        raise PlugSignature.ConfigError, "cannot use infinite validity with legacy algorithms"

      _from.._to ->
        :ok

      _otherwise ->
        raise PlugSignature.ConfigError, "validity must be a range"
    end

    %{
      headers: headers,
      header_list: header_list,
      default_headers: @legacy_default_headers,
      validity: validity,
      check_date_header: "date" in header_list
    }
  end

  defp opts_for_algorithm(algorithm, _opts) do
    raise PlugSignature.ConfigError, "unknown algorithm: '#{algorithm}'"
  end

  # Make sure all header list values are legal HTTP header names or known
  # pseudo-headers for the specific algorithm

  defp validate_header_list!([], _algorithm) do
    raise PlugSignature.ConfigError, "header list must not be empty"
  end

  defp validate_header_list!(headers, algorithm) do
    headers
    |> Enum.reject(&is_standard_header?/1)
    |> validate_pseudo_header_list!(algorithm)
  end

  defp validate_pseudo_header_list!([], _algorithm), do: :ok

  defp validate_pseudo_header_list!(["(request-target)" | more], algorithm) do
    validate_pseudo_header_list!(more, algorithm)
  end

  defp validate_pseudo_header_list!(["(created)" | more], "hs2019" = algorithm) do
    validate_pseudo_header_list!(more, algorithm)
  end

  defp validate_pseudo_header_list!(["(expires)" | more], "hs2019" = algorithm) do
    validate_pseudo_header_list!(more, algorithm)
  end

  defp validate_pseudo_header_list!([header | _], _algorithm) do
    raise PlugSignature.ConfigError, "invalid header '#{header}'"
  end

  defp is_standard_header?(header) do
    header =~ ~r/^[!#-'*+\-.0-9^-z|~]+$/
  end

  defp validate_on_success(nil), do: nil
  defp validate_on_success({m, f, a}) when is_atom(m) and is_atom(f) and is_list(a), do: {m, f, a}
  defp validate_on_success(fun) when is_function(fun, 2) or is_function(fun, 1), do: fun

  defp validate_on_success(_) do
    raise PlugSignature.ConfigError, "invalid value for `:on_success`"
  end

  defp validate_on_failure(nil), do: nil
  defp validate_on_failure({m, f, a}) when is_atom(m) and is_atom(f) and is_list(a), do: {m, f, a}

  defp validate_on_failure(fun)
       when is_function(fun, 4) or is_function(fun, 2) or is_function(fun, 1),
       do: fun

  defp validate_on_failure(_) do
    raise PlugSignature.ConfigError, "invalid value for `:on_failure`"
  end
end
