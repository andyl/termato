defmodule Termato.MixProject do
  use Mix.Project

  def project do
    [
      app: :termato,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Termato.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.3"}, 
      {:plug_socket, "~> 0.1.0"}, 
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.8"}, 
    ]
  end
end
