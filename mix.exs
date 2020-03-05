defmodule Usps.MixProject do
  use Mix.Project

  def project do
    [
      app: :usps,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hackney, "~> 1.15", optional: true},
      {:html_sanitize_ex, "~> 1.4"},
      {:sweet_xml, "~> 0.6.6"},
      {:xml_builder, "~> 2.1"}
    ]
  end
end
