defmodule PlugSignatureExample.Client do
  def new(key_id, key_path) do
    private_key =
      key_path
      |> File.read!()
      |> X509.PrivateKey.from_pem!()

    Tesla.client([
      {Tesla.Middleware.BaseUrl, "http://localhost:4040"},
      # Ensure body is encoded before invoking HttpSignatureAuth, so a
      # digest can be calculated
      Tesla.Middleware.FormUrlencoded,
      {PlugSignatureExample.Middleware.HttpSignatureAuth,
       key_id: key_id, private_key: private_key, headers: "(request-target) (created) host digest"},
      Tesla.Middleware.Logger
    ])
  end

  def get(client, params) do
    Tesla.get(client, "/", query: params)
  end

  def post(client, params) do
    Tesla.post(client, "/", params)
  end
end
