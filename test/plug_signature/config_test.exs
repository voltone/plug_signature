defmodule PlugSignature.ConfigTest do
  use ExUnit.Case
  doctest PlugSignature.Config

  describe "common settings" do
    test "requires callback_module" do
      assert_raise PlugSignature.ConfigError, "missing mandatory option `:callback_module`", fn ->
        PlugSignature.init([])
      end
    end

    test "defaults to 'hs2019'" do
      opts = PlugSignature.init(callback_module: SomeModule)
      assert "hs2019" = Keyword.get(opts, :default_algorithm)
      assert ["hs2019"] = opts |> Keyword.get(:algorithms) |> Map.keys()
    end

    test "fails on empty algorithms" do
      assert_raise PlugSignature.ConfigError, "algorithm list is empty", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: []
        )
      end
    end

    test "supports all algorithms" do
      all = ["rsa-sha256", "rsa-sha1", "ecdsa-sha256", "hmac-sha256", "hs2019"]

      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: all
        )

      assert "rsa-sha256" = Keyword.get(opts, :default_algorithm)

      Enum.each(all, fn algorithm ->
        assert Map.has_key?(Keyword.get(opts, :algorithms), algorithm)
      end)
    end

    test "fails on unknown algorithm" do
      assert_raise PlugSignature.ConfigError, "unknown algorithm: 'ecdsa-sha1'", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["ecdsa-sha1"]
        )
      end
    end

    test "checks on_success value" do
      assert_raise PlugSignature.ConfigError, "invalid value for `:on_success`", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          on_success: fn -> :ok end
        )
      end
    end

    test "checks on_failure value" do
      assert_raise PlugSignature.ConfigError, "invalid value for `:on_failure`", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          on_failure: {SomeModule, :failure}
        )
      end
    end
  end

  describe "hs2019" do
    test "allows all pseudo-headers" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019"],
          headers: "(created) (expires) (request-target)"
        )

      assert %{"hs2019" => alg_opts} = Keyword.get(opts, :algorithms)
      assert "(created) (expires) (request-target)" = alg_opts.headers
      assert ["(created)", "(expires)", "(request-target)"] = alg_opts.header_list
    end

    test "disallows unknown pseudo-headers" do
      assert_raise PlugSignature.ConfigError, "invalid header '(request-method)'", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019"],
          headers: "(created) (request-method)"
        )
      end
    end

    test "allows any legal HTTP headers" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019"],
          headers: "X-Some-Header MD5-digest weird!"
        )

      assert %{"hs2019" => alg_opts} = Keyword.get(opts, :algorithms)
      assert "X-Some-Header MD5-digest weird!" = alg_opts.headers
      assert ["x-some-header", "md5-digest", "weird!"] = alg_opts.header_list
    end

    test "disallows illegal HTTP headers" do
      assert_raise PlugSignature.ConfigError, "invalid header 'illegal:header'", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019"],
          headers: "(created) illegal:header"
        )
      end
    end

    test "allows infinite validity, with (expires)" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019"],
          headers: "(request-target) (expires)",
          validity: :infinity
        )

      assert %{"hs2019" => alg_opts} = Keyword.get(opts, :algorithms)
      assert :infinity = alg_opts.validity
    end

    test "disallows infinite validity without (expires)" do
      assert_raise PlugSignature.ConfigError,
                   "missing pseudo-header `(expires)` in header list",
                   fn ->
                     PlugSignature.init(
                       callback_module: SomeModule,
                       algorithms: ["hs2019"],
                       headers: "(request-target) (created)",
                       validity: :infinity
                     )
                   end
    end

    test "checks validity type" do
      assert_raise PlugSignature.ConfigError,
                   "validity must be a range, or `:infinity`",
                   fn ->
                     PlugSignature.init(
                       callback_module: SomeModule,
                       algorithms: ["hs2019"],
                       headers: "(request-target) (created)",
                       validity: 300
                     )
                   end
    end
  end

  describe "legacy algorithms" do
    test "allows (request-target) pseudo-headers" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["rsa-sha256"],
          headers: "(request-target)"
        )

      assert %{"rsa-sha256" => alg_opts} = Keyword.get(opts, :algorithms)
      assert "(request-target)" = alg_opts.headers
      assert ["(request-target)"] = alg_opts.header_list
    end

    test "disallows other pseudo-headers" do
      assert_raise PlugSignature.ConfigError, "invalid header '(created)'", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["rsa-sha256"],
          headers: "(created)"
        )
      end
    end

    test "allows any legal HTTP headers" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["rsa-sha256"],
          headers: "X-Some-Header MD5-digest weird!"
        )

      assert %{"rsa-sha256" => alg_opts} = Keyword.get(opts, :algorithms)
      assert "X-Some-Header MD5-digest weird!" = alg_opts.headers
      assert ["x-some-header", "md5-digest", "weird!"] = alg_opts.header_list
    end

    test "disallows illegal HTTP headers" do
      assert_raise PlugSignature.ConfigError, "invalid header 'illegal:header'", fn ->
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["rsa-sha256"],
          headers: "date illegal:header"
        )
      end
    end

    test "disallows infinite validity " do
      assert_raise PlugSignature.ConfigError,
                   "cannot use infinite validity with legacy algorithms",
                   fn ->
                     PlugSignature.init(
                       callback_module: SomeModule,
                       algorithms: ["rsa-sha256"],
                       headers: "(request-target) date",
                       validity: :infinity
                     )
                   end
    end

    test "checks validity type" do
      assert_raise PlugSignature.ConfigError,
                   "validity must be a range",
                   fn ->
                     PlugSignature.init(
                       callback_module: SomeModule,
                       algorithms: ["rsa-sha256"],
                       headers: "(request-target) date",
                       validity: 300
                     )
                   end
    end
  end

  describe "hs2019 mixed with legacy algorithms" do
    test "with default headers and validity" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019", "rsa-sha256"]
        )

      assert %{"hs2019" => hs2019_opts, "rsa-sha256" => legacy_opts} =
               Keyword.get(opts, :algorithms)

      assert "(created)" = hs2019_opts.headers
      assert -300..30 == hs2019_opts.validity
      assert false == hs2019_opts.check_date_header

      assert "date" = legacy_opts.headers
      assert -300..30 == legacy_opts.validity
      assert true == legacy_opts.check_date_header
    end

    test "fails with incompatible headers" do
      assert_raise PlugSignature.ConfigError,
                   "invalid header '(created)'",
                   fn ->
                     PlugSignature.init(
                       callback_module: SomeModule,
                       algorithms: ["hs2019", "rsa-sha256"],
                       headers: "(request-target) (created) host"
                     )
                   end
    end

    test "with custom legacy options" do
      opts =
        PlugSignature.init(
          callback_module: SomeModule,
          algorithms: ["hs2019", "rsa-sha256"],
          headers: "(request-target) (expires) host",
          validity: :infinity,
          legacy: [
            headers: "(request-target) date host",
            validity: -300..30
          ]
        )

      assert %{"hs2019" => hs2019_opts, "rsa-sha256" => legacy_opts} =
               Keyword.get(opts, :algorithms)

      assert "(request-target) (expires) host" = hs2019_opts.headers
      assert :infinity = hs2019_opts.validity
      assert false == hs2019_opts.check_date_header

      assert "(request-target) date host" = legacy_opts.headers
      assert -300..30 == legacy_opts.validity
      assert true == legacy_opts.check_date_header
    end
  end
end
