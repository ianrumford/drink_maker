defmodule TeaMaker do
  
  # build the drinks_menu
  use DrinkMaker.Menu

  # header
  def make_drink(state, verb, opts \\ [])
  def make_drink(state, :add_earl_grey_tea_bag, _opts) do
    # blah
    state
  end
  def make_drink(state, :brew_for_3_minutes, _opts) do
    # blah
    state
  end

  # this is the TeaMaker variant rewritten to use the DrinkMaker.Menu helper
  def make_drink(state, :make_earl_grey_tea, opts) do
    verbs = [:boil_water, :wash_cup, 
             :add_earl_grey_tea_bag, :brew_for_3_minutes,
             # more verbs here
            ]
    state 
    |> DrinkMaker.Menu.make_drink(verbs, opts)
    # mark the drink ready
    |> Map.put(:ready_drink, :earl_grey_tea)
  end
end
