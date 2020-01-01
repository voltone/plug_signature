defmodule PlugSignature.Callback do
  @moduledoc """
  Behaviour for the callback module that implements client and credential
  lookup for `PlugSignature`.

  ## Example

      defmodule MyApp.SignatureAuth do
        @behaviour PlugSignature.Callback

        @impl true
        def client_lookup(key_id, "hs2019", _conn) do
          # ...
          {:ok, client, client.hmac_secret}
        end
      end
  """

  @doc """
  Takes the keyId from the parsed Authorization header, the algorithm name and
  the `Plug.Conn` struct, and returns a success or error tuple.

  In case of success, an application-specific term is returned that identifies
  the client, along with that client's credentials (a public key or HMAC
  secret).

  The `Plug.Conn` struct may be used to select the relevant client, but it
  cannot be modified. For instance, the hostname of the request may be needed
  to select the correct client in a multi-tennant application.
  """
  @callback client_lookup(key_id :: binary(), algorithm :: binary(), conn :: Plug.Conn.t()) ::
              {:ok, any(), :public_key.public_key() | binary()} | {:error, String.t()}
end
