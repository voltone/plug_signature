defmodule PlugSignatureExample.Middleware.HttpSignatureAuth do
  @moduledoc """
  Tesla middleware for HTTP request signing according to
  https://tools.ietf.org/html/draft-cavage-http-signatures-11

  Supports the hs2019 algorithm only.
  """

  alias PlugSignature.Crypto

  @behaviour Tesla.Middleware

  def call(env, next, opts) do
    key_id = opts[:key_id]
    private_key = opts[:private_key]
    headers = Keyword.get(opts, :headers, "(created)")

    env
    |> with_digest()
    |> signed(key_id, private_key, headers)
    |> Tesla.run(next)
  end

  defp with_digest(%{body: body} = env) do
    Tesla.put_header(env, "digest", "SHA-256=#{digest(body)}")
  end

  defp digest(nil), do: :crypto.hash(:sha256, "") |> Base.encode64()
  defp digest(body), do: :crypto.hash(:sha256, body) |> Base.encode64()

  defp signed(env, key_id, private_key, headers) do
    created =
      DateTime.utc_now()
      |> DateTime.to_unix()

    to_sign = build_to_sign(headers, env, created)

    signature =
      to_sign
      |> Crypto.sign!("hs2019", private_key)
      |> Base.encode64()

    authorization =
      ~s[Signature keyId="#{key_id}",signature="#{signature}",algorithm="hs2019",created=#{
        created
      },headers="#{headers}"]

    Tesla.put_header(env, "authorization", authorization)
  end

  defp build_to_sign(headers, env, created) do
    url = URI.parse(env.url)
    path = url.path
    host = url.authority

    query =
      case {url.query, URI.encode_query(env.query)} do
        {nil, ""} -> ""
        {from_url, ""} when byte_size(from_url) > 0 -> "?" <> from_url
        {nil, from_env} when byte_size(from_env) > 0 -> "?" <> from_env
      end

    request_target = "#{env.method |> to_string() |> String.downcase()} #{path}#{query}"

    headers
    |> String.split()
    |> Enum.map(fn
      "(request-target)" ->
        "(request-target): #{request_target}"

      "(created)" ->
        "(created): #{created}"

      "host" ->
        "host: #{host}"

      header ->
        "#{header}: #{Tesla.get_header(env, header)}"
    end)
    |> Enum.join("\n")
  end
end
