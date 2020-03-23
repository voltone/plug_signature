defmodule PlugSignature.SignatureString do
  @moduledoc false

  def build(conn, signature_opts, algorithm, header_list) do
    signature_string =
      Enum.map_join(header_list, "\n", &header_part(conn, signature_opts, algorithm, &1))

    {:ok, signature_string}
  rescue
    # Handle the case where (created) or (expires) pseudo header is not
    # available or not supported by the algorithm
    _key_error -> {:error, "could not build signature_string"}
  end

  defp header_part(conn, _signature_opts, _algorithm, "(request-target)") do
    query_part =
      case conn.query_string do
        "" -> ""
        query -> "?#{query}"
      end

    "(request-target): #{String.downcase(conn.method)} #{conn.request_path}#{query_part}"
  end

  defp header_part(_conn, signature_opts, "hs2019", "(created)") do
    "(created): #{Keyword.fetch!(signature_opts, :created)}"
  end

  defp header_part(_conn, signature_opts, "hs2019", "(expires)") do
    "(expires): #{Keyword.fetch!(signature_opts, :expires)}"
  end

  defp header_part(conn, _signature_opts, _algorithm, header)
       when header not in ["(created)", "(expires)"] do
    header_name = String.downcase(header)

    values =
      conn.req_headers
      |> Enum.filter(&match?({^header_name, _}, &1))
      |> Enum.map(&String.trim(elem(&1, 1)))

    if values == [], do: raise("Missing header")

    "#{header_name}: #{Enum.join(values, ", ")}"
  end
end
