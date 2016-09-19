defmodule CoffeeMaker do
  
  # build the drinks_menu
  use DrinkMaker.Menu

  # header
  def make_drink(state, verb, opts \\ [])
  def make_drink(state, :boil_water, _opts) do
    # blah
    state
  end
  def make_drink(state, :wash_cup, _opts) do
    # blah
    state
  end
  def make_drink(state, :add_instant_coffee_to_cup, _opts) do
    # blah
    state
  end
  # more steps (verbs) in the recipe 
  
  # this variant recursively calls make_drink
  def make_drink(state, :make_instant_coffee, opts) do
    [:boil_water, :wash_cup, :add_instant_coffee_to_cup,
       # more verbs here
    ]
    |> Enum.reduce(state, fn verb, state -> make_drink(state, verb, opts) end)
    # mark the drink ready
    |> Map.put(:ready_drink, :instant_coffee)
  end
end
