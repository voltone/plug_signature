defmodule PlugSignature.CallbacksTest do
  use ExUnit.Case
  doctest PlugSignature.Callback

  import PlugSignature.ConnTest
  import ExUnit.CaptureLog
  require Logger

  defmodule Callback do
    # Sample callback module for use in tests
    require Logger

    @behaviour PlugSignature.Callback

    @private_ec X509.PrivateKey.new_ec(:secp256r1)
    @public_ec X509.PublicKey.derive(@private_ec)

    @impl true
    def client_lookup("no_such_client", _algorithm, _conn) do
      {:error, "no client for key_id"}
    end

    def client_lookup("key_id", "hs2019", _conn) do
      {:ok, "some client", @public_ec}
    end

    def client_lookup("key_id", _algorithm, _conn) do
      {:error, "no credentials for algorithm"}
    end

    def success(conn, client) do
      Logger.info("Signature auth successful; client='#{client}'")
      Plug.Conn.assign(conn, :client, client)
    end

    def failure(conn, "no client for key_id", algorithm, _headers) do
      Logger.warn("Invalid key ID (#{algorithm})")

      conn
      |> Plug.Conn.send_resp(403, "")
      |> Plug.Conn.halt()
    end

    def private(), do: @private_ec
  end

  setup_all do
    [config: [callback_module: Callback]]
  end

  describe "PlugSignature.Callback.client_lookup/2" do
    test "success", %{config: config} do
      priv = config[:callback_module].private()

      conn =
        conn()
        |> with_signature(priv, "key_id", config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
    end

    test "bad key_id", %{config: config} do
      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "no_such_client", config)
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "no client for key_id"
    end

    test "bad algorithm", %{config: config} do
      config = Keyword.put(config, :algorithms, ["ecdsa-sha256"])
      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "key_id", config)
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 401
      end

      assert capture_log(scenario) =~ "no credentials for algorithm"
    end
  end

  describe "on_success" do
    test "{m, f, a}", %{config: config} do
      config = Keyword.put(config, :on_success, {Callback, :success, []})
      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "key_id", config)
          |> PlugSignature.call(PlugSignature.init(config))

        refute conn.halted
        assert conn.assigns[:client] == "some client"
      end

      assert capture_log(scenario) =~ "client='some client'"
    end

    test "anonymous/2", %{config: config} do
      config =
        Keyword.put(config, :on_success, fn conn, client ->
          Plug.Conn.assign(conn, :client, client)
        end)

      priv = config[:callback_module].private()

      conn =
        conn()
        |> with_signature(priv, "key_id", config)
        |> PlugSignature.call(PlugSignature.init(config))

      refute conn.halted
      assert conn.assigns[:client] == "some client"
    end

    test "anonymous/1", %{config: config} do
      config =
        Keyword.put(config, :on_success, fn conn ->
          Logger.info("Signature auth successful")
          Plug.Conn.assign(conn, :success, true)
        end)

      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "key_id", config)
          |> PlugSignature.call(PlugSignature.init(config))

        refute conn.halted
        assert conn.assigns[:success] == true
      end

      assert capture_log(scenario) =~ "Signature auth successful"
    end
  end

  describe "on_failure" do
    test "{m, f, a}", %{config: config} do
      config = Keyword.put(config, :on_failure, {Callback, :failure, []})
      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "no_such_client", config)
          |> PlugSignature.call(PlugSignature.init(config))

        assert conn.halted
        assert conn.status == 403
      end

      refute capture_log(scenario) =~ "no client for key_id"
    end

    test "anonymous/4", %{config: config} do
      config =
        Keyword.put(config, :on_failure, fn conn, reason, algorithm, headers ->
          Plug.Conn.assign(conn, :auth, {:failed, reason, algorithm, headers})
        end)

      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "no_such_client", config)
          |> PlugSignature.call(PlugSignature.init(config))

        refute conn.halted
        assert {:failed, "no client for key_id", "hs2019", "(created)"} = conn.assigns[:auth]
      end

      refute capture_log(scenario) =~ "no client for key_id"
    end

    test "nil", %{config: config} do
      config = Keyword.put(config, :on_failure, nil)
      priv = config[:callback_module].private()

      scenario = fn ->
        conn =
          conn()
          |> with_signature(priv, "no_such_client", config)
          |> PlugSignature.call(PlugSignature.init(config))

        refute conn.halted
      end

      refute capture_log(scenario) =~ "no client for key_id"
    end
  end

  defp conn() do
    Plug.Test.conn(:get, "/")
  end
end
