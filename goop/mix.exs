defmodule Goop.MixProject do
  use Mix.Project

  def project do
    [
      app: :goop,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Goop, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.5"},
      # database stuff
      {:ecto_sql, "~> 3.6"},
      {:postgrex, "~> 0.15.9"},
      # json encoder
      {:jason, "~> 1.2"},
      # HTTP Client
      {:httpoison, "~> 1.8"},
      # JWT
      {:joken, "~> 2.3.0"},
      # local registry management
      {:gen_registry, "~> 1.0"}
    ]
  end
end
