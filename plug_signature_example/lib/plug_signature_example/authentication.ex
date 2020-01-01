defmodule PlugSignatureExample.Authentication do
  @moduledoc """
  Wrapper around PlugSignature
  """

  @behaviour PlugSignature.Callback

  @impl true
  def client_lookup("hmac.key", _algorithm, _conn) do
    {:ok, "Some client", File.read!("priv/hmac.key")}
  end

  def client_lookup(key_id, _algorithm, _conn) do
    path = Application.app_dir(:plug_signature_example, "priv")

    with {:ok, pem} <- File.read(Path.join(path, key_id)),
         {:ok, public_key} <- X509.PublicKey.from_pem(pem) do
      {:ok, "Some client", public_key}
    else
      _error ->
        {:error, "Key not found"}
    end
  end
end
