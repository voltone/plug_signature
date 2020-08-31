defmodule PlugSignature.MixProject do
  use Mix.Project

  @version "0.8.0"

  def project do
    [
      app: :plug_signature,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/voltone/plug_signature"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto, :public_key]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5"},
      {:nimble_parsec, "~> 0.5", only: :dev},
      {:ex_doc, "~> 0.21", only: :dev},
      {:credo, "~> 1.1", only: :dev},
      {:x509, "~> 0.5", only: :test},
      {:cowlib, "~> 2.8", only: :test}
    ]
  end

  defp description do
    "Server side implementation of IETF HTTP signature draft as a reusable Plug"
  end

  defp package do
    [
      maintainers: ["Bram Verburg"],
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => "https://github.com/voltone/plug_signature"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
