defmodule DrinkMaker do

  use GenServer
  
  # need to require all the drinks dsl module to ensure the individual
  # modules' drinks_menus have been created
  require CoffeeMaker
  require TeaMaker
  # require any other drink dsl modules
  
  # create drinks_menu as a module attribute
  @drinks_menu [CoffeeMaker, TeaMaker]
  |> Stream.map(fn module -> module |> DrinkMaker.Menu.get_drinks_menu end)
  |> Enum.reduce(%{}, fn m, s -> s |> Map.merge(m) end)

  # start the GenServer
  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state)
  end

  # use Amlapio to generate the accessors and mutators for the drinks_menu and state
  use Amlapio, funs: [:get, :put], genserver_api: [:drinks_menu]
  use Amlapio, funs: [:get, :put], genserver_api: nil,
    namer: fn _map_name, fun_name -> 
    ["drink_maker_state_", to_string(fun_name)] |> Enum.join |> String.to_atom
  end
  
  # << more API calls >>

  def make_drink(pid, verbs, opts \\ []) do
    GenServer.call(pid, {:make_drink, verbs, opts})
  end

  # GenServer Callbacks

  def init(state \\ %{}) when is_map(state) do
    # merge the drinks_menu to the state
    drinks_menu = state
    |> Map.get(:drinks_menu, %{})
    # any drinks_menu in the state overrides the default drinks_menu
    |> Map.merge(@drinks_menu, fn _k, v1, _v2 -> v1 end)

    {:ok, state |> Map.put(:drinks_menu, drinks_menu)}
  end

  # make_drink's handle_call
  def handle_call({:make_drink, verbs, opts}, _fromref, state) do

    state = state
    |> DrinkMaker.Menu.make_drink(verbs, opts)

    # reply with result self and (updated) state
    {:reply, self, state}    

  end

  # use Amlapio to generate the accessors and mutators for the drinks_menu
  use Amlapio, funs: [:get, :put], genserver_handle_call: [:drinks_menu]
  use Amlapio, funs: [:get, :put], genserver_handle_call: nil,
    namer: fn _map_name, fun_name -> 
    ["drink_maker_state_", to_string(fun_name)] |> Enum.join |> String.to_atom
  end
  
end
