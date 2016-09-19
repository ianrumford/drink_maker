defmodule AgentMapTest do
  use ExUnit.Case
  require DrinkMaker

  test "drink_maker" do
  
    # create a drink maker for Jane and Lucy
    {:ok, janes_drink_maker} = DrinkMaker.start_link
    {:ok, lucys_drink_maker} = DrinkMaker.start_link
  
    # add Jane's favourite drink (instant coffee) to her drinks menu
    instant_cofffe_recipe =
      DrinkMaker.drinks_menu_get(janes_drink_maker, :make_instant_coffee)
    
    assert janes_drink_maker == janes_drink_maker
    |> DrinkMaker.drinks_menu_put(:make_my_favourite_drink, instant_cofffe_recipe) 
  
    # Lucy prefers Earl Grey tea
    earl_grey_tea_recipe =
      DrinkMaker.drinks_menu_get(janes_drink_maker, :make_earl_grey_tea)
    
    assert lucys_drink_maker == lucys_drink_maker 
    |> DrinkMaker.drinks_menu_put(:make_my_favourite_drink, earl_grey_tea_recipe)
  
    # now can make their favourite drink in a polymorphic way
    assert janes_drink_maker == janes_drink_maker
    |> DrinkMaker.make_drink(:make_my_favourite_drink)
  
    assert lucys_drink_maker == lucys_drink_maker
    |> DrinkMaker.make_drink(:make_my_favourite_drink)
    
    # check the drinks are the right ones
    assert :instant_coffee == janes_drink_maker
    |> DrinkMaker.drink_maker_state_get(:ready_drink)
  
    assert :earl_grey_tea == lucys_drink_maker
    |> DrinkMaker.drink_maker_state_get(:ready_drink)
  
  end
end
