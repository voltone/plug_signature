defmodule PlugSignatureExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_signature_example,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PlugSignatureExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_signature, path: ".."},
      {:plug_body_digest, "~> 0.5"},
      {:plug_cowboy, "~> 2.1"},
      {:x509, "~> 0.5"},
      {:tesla, "~> 1.3"}
    ]
  end
end
