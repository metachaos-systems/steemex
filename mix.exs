defmodule Steemex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :steemex,
      version: "0.14.1",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [], mod: {Steemex, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:websockex, "~> 0.4.0"},
      {:poison, "~> 3.1.0"},
      {:gen_stage, ">= 0.0.0"},
      {:atomic_map, "~> 0.9.0"},
      {:credo, ">= 0.0.0", only: [:test, :dev]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:exconstructor, ">= 0.0.0"},
      {:jsonrpc2, "~> 1.0"},
      {:hackney, ">= 0.0.0"}
    ]
  end

  defp description do
    """
    Elixir HTTP/Websockets client library for official Steemit API and standard steemd JSONRPC interface. Includes module for pseudo realtime streaming of block, transaction and operation events.
    """
  end

  defp package do
    [
      name: :steemex,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["ontofractal"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/cyberpunk-ventures/steemex",
        "Cyberpunk Ventures" => "http://cyberpunk.ventures"
      }
    ]
  end
end
