defmodule Usps.MixProject do
  use Mix.Project

  @name :usps
  @url "https://github.com/christopherlai/usps"

  def project do
    [
      app: @name,
      version: "0.1.0",
      description: "Wrapper for the USPS API.",
      source_url: @url,
      homepage_url: @url,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:hackney, "~> 1.15", optional: true},
      {:html_sanitize_ex, "~> 1.4"},
      {:mox, "~> 0.5", only: [:test]},
      {:sweet_xml, "~> 0.6.6"},
      {:xml_builder, "~> 2.1"}
    ]
  end

  defp package do
    [
      name: @name,
      licenses: ["MIT"],
      links: %{github: @url}
    ]
  end
end
