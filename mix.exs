  defmodule Steemex.Mixfile do
  use Mix.Project

  def project do
    [app: :steemex,
     version: "0.9.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :websocket_client],
    mod: {Steemex, []}]
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
      {:websocket_client, "~> 1.2.0"},
      {:poison, "~> 2.0"},
      {:atomic_map, ">= 0.0.0"},
      {:credo, ">= 0.0.0", only: [:test, :dev]},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description do
    """
    Elixir websockets library and utilities for Steem blockchain client
    """
  end

  defp package do
    [
     name: :steemex,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["ontofractal"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/cyberpunk-ventures/steemex"}
   ]
  end
end
