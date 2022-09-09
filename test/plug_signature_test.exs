defmodule PlugSignatureTest do
  use ExUnit.Case
  doctest PlugSignature

  import Plug.Conn
  import PlugSignature.ConnTest
  import ExUnit.CaptureLog

  defmodule Sample do
    # Sample callback module for use in tests
    @behaviour PlugSignature.Callback

    @private_ec X509.PrivateKey.new_ec(:secp256r1)
    @public_ec X509.PublicKey.derive(@private_ec)
    @private_rsa X509.PrivateKey.new_rsa(2048)
    @public_rsa X509.PublicKey.derive(@private_rsa)
    @secret "supersecret"

    @impl true
    def client_lookup("ecdsa", "hs2019", _conn), do: {:ok, nil, @public_ec}
    def client_lookup("rsa", "hs2019", _conn), do: {:ok, nil, @public_rsa}
    def client_lookup("hmac", "hs2019", _conn), do: {:ok, nil, @secret}
    def client_lookup(_, "ecdsa-" <> _, _conn), do: {:ok, nil, @public_ec}
    def client_lookup(_, "rsa-" <> _, _conn), do: {:ok, nil, @public_rsa}
    def client_lookup(_, "hmac" <> _, _conn), do: {:ok, nil, @secret}

    def private("ecdsa"), do: @private_ec
    def private("rsa"), do: @private_rsa
    def private("hmac"), do: @secret
  end

  defp setup_hs2019_ecdsa(_context), do: do_setup("hs2019", "ecdsa")
  defp setup_hs2019_rsa(_context), do: do_setup("hs2019", "rsa")
  defp setup_hs2019_hmac(_context), do: do_setup("hs2019", "hmac")
  defp setup_rsa_sha256(_context), do: do_setup("rsa-sha256", "rsa")
  defp setup_rsa_sha1(_context), do: do_setup("rsa-sha1", "rsa")
  defp setup_ecdsa_sha256(_context), do: do_setup("ecdsa-sha256", "ecdsa")
  defp setup_hmac_sha256(_context), do: do_setup("hmac-sha256", "hmac")

  defp do_setup(algorithm, key_type) do
    timestamp =
      case algorithm do
        "hs2019" -> "(created)"
        _ -> "date"
      end

    [
      algorithm: algorithm,
      key_id: key_type,
      key: Sample.private(key_type),
      config: [
        callback_module: Sample,
        algorithms: [algorithm],
        headers: "(request-target) #{timestamp} host",
        validity: -60..15
      ]
    ]
  end

  describe "hs2019 ECDSA" do
    setup [:setup_hs2019_ecdsa]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "valid, in Signature header", %{config: config, key: key, key_id: key_id} do
      config = Keyword.put(config, :header_name, "signature")

      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "valid, expires in the future", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, Keyword.put(config, :expires_in, 30))
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "valid, extra Authorization header", %{config: config, key: key, key_id: key_id} do
      extra_header = {"authorization", "Basic ZXhhbXBsZTpzZWNyZXQ="}

      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> Map.update(:req_headers, [extra_header], &[extra_header | &1])
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "invalid, missing Authorization header", %{config: config} do
      scenario = fn ->
        conn =
          conn()
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "no authorization header"
    end

    test "invalid, missing Signature header", %{config: config} do
      config = Keyword.put(config, :header_name, "signature")

      scenario = fn ->
        conn =
          conn()
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "no signature header"
    end

    test "invalid, unexpected Authorization scheme", %{config: config} do
      scenario = fn ->
        conn =
          conn()
          |> put_req_header("authorization", "Bearer 123")
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "no signature in authorization header"
    end

    test "invalid, missing keyId", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :key_id_override, ""))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "key key_id not found"
    end

    test "invalid, missing signature", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :signature_override, ""))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "key signature not found"
    end

    test "invalid, malformed signature", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :signature, "12345"))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "Base64 decoding failed"
    end

    test "invalid, insufficient header coverage", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created)"

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "insufficient signature coverage"
    end

    test "invalid, mismatched host header", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, config)
          |> put_req_header("host", "example.org")
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "incorrect signature"
    end

    test "invalid, mismatched optional header", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created) host user-agent"

      scenario = fn ->
        conn =
          conn()
          |> put_req_header("user-agent", "test")
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> put_req_header("user-agent", "wrong")
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "incorrect signature"
    end

    test "invalid, missing 'created' timestamp", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :created_override, ""))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "could not build signature_string"
    end

    test "invalid, malformed 'created' timestamp", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :created, "10a19"))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "malformed signature creation timestamp"
    end

    test "invalid, old 'created' timestamp", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :age, 120))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "request expired"
    end

    test "invalid, future 'created' timestamp", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :age, -60))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "request timestamp in the future"
    end

    test "invalid, expired", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created) (expires) host digest"

      config =
        config
        |> Keyword.put(:headers, headers)
        |> Keyword.put(:expires_in, -30)

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, config)
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "request expired"
    end

    test "invalid, missing header", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created) host digest nosuchheader"

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "could not build signature_string"
    end

    test "invalid, missing expires param", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created) (expires) host digest"

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "could not build signature_string"
    end
  end

  describe "hs2019 RSA" do
    setup [:setup_hs2019_rsa]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end
  end

  describe "hs2019 HMAC" do
    setup [:setup_hs2019_hmac]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end
  end

  describe "rsa-sha256" do
    setup [:setup_rsa_sha256]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "invalid, wrong algorithm", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :algorithms, ["hs2019"]))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "bad signing algorithm"
    end

    test "invalid, old Date header", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :age, 120))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "request expired"
    end

    test "invalid, future Date header", %{config: config, key: key, key_id: key_id} do
      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :age, -60))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "request timestamp in the future"
    end

    test "invalid, (created) pseudo header", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (created) date host digest"

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "could not build signature_string"
    end

    test "invalid, (expires) pseudo header", %{config: config, key: key, key_id: key_id} do
      headers = "(request-target) (expires) date host digest"

      scenario = fn ->
        conn =
          conn()
          |> with_signature(key, key_id, Keyword.put(config, :headers, headers))
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "could not build signature_string"
    end
  end

  describe "rsa-sha" do
    setup [:setup_rsa_sha1]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end
  end

  describe "ecdsa-sha256" do
    setup [:setup_ecdsa_sha256]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end
  end

  describe "hmac-sha256" do
    setup [:setup_hmac_sha256]

    test "valid", %{config: config, key: key, key_id: key_id} do
      conn =
        conn()
        |> with_signature(key, key_id, config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end
  end

  defp conn() do
    host = "localhost:4000"

    Plug.Test.conn(:get, "http://#{host}/")
  end
end
