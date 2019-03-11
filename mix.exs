defmodule Results.MixProject do
  use Mix.Project

  def project do
    [
      app: :results,
      version: "0.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :maru, :jason, :csv],
      mod: {Results, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:maru, "~> 0.13.2"},
      {:cowboy, "~> 2.6.1"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:csv, "~> 2.2"},
      {:exprotobuf, "~> 1.2.9"},
      {:distillery, "~> 2.0"}
    ]
  end
end
