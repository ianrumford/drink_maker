defmodule DrinkMaker.Mixfile do
  use Mix.Project
  def project do
    [app: :drink_maker,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description,
     package: package,
     #build_embedded: Mix.env == :prod,
     #start_permanent: Mix.env == :prod,
     deps: deps]
  end
  def application do
    [applications: [:logger]]
  end
  defp deps do
    [{:amlapio, "~> 0.1.0"}]
  end
  defp package do
    [maintainers: ["Ian Rumford"],
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/ianrumford/drink_maker"}]
  end
  defp description do
  """
  DrinkMaker:  the example code to go with my blog post Pattern Matching to Polymorphism
  """     
  end
end
