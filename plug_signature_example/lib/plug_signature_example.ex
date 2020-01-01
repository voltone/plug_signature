defmodule PlugSignatureExample do
  use Plug.Builder
  import Plug.Conn

  plug Plug.Parsers,
    parsers: [:urlencoded],
    body_reader: {PlugBodyDigest, :digest_body_reader, []}

  plug Plug.Logger

  plug PlugBodyDigest

  plug PlugSignature,
    callback_module: PlugSignatureExample.Authentication,
    on_success: {PlugSignature, :assign_client, [:client]},
    headers: "(request-target) (created) host digest"

  plug :echo

  def echo(conn, _opts) do
    client = conn.assigns[:client]
    params = conn.params
    send_resp(conn, 200, "Client: #{client}\nParams: #{inspect(params)}\n\n")
  end
end
