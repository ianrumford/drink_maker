defmodule DrinkMaker.Menu do
 
  # header
  def make_drink_on_def_callback(env, kind, name, args, guards, body)
  
  # ignore any bodyless functions; likely headers
  def make_drink_on_def_callback(_env, _kind, _name, _args, _guards, nil), do: nil
  
  # add new make_drink variants to the drinks_menu
  def make_drink_on_def_callback(env, :def, :make_drink, args, _guards, _body) do
  
    # the calling module e.g. CoffeeMaker is the env's module key
    env_module = env.module
  
    # the verb is the second item in the args
    verb = args |> Enum.at(1)
  
    # update the current drinks_menu with new entry
    drinks_menu = env_module
    |> Module.get_attribute(:drinks_menu)
    # add the new verb + MFA 3tuple
    |> Map.put(verb, {env_module, :make_drink, [verb]})
    
    # save the update drinks_menu in the persistent attribute
    env_module |> Module.put_attribute(:drinks_menu, drinks_menu)
    
  end
  
  # default => do nothing
  def make_drink_on_def_callback(_env, _kind, _name, _args, _guards, _body) do
  end
  
  # get module's e.g. CoffeeMaker drinks_menu at run time
  def get_drinks_menu(module) do
    :attributes
    |> module.__info__
    |> Keyword.fetch!(:drinks_menu)
    # persist always seems to make the attribute a List of one item
    |> List.first
  end
  def make_drink(state, verbs, opts \\ []) do
  
    # the drinks_menu must be in the state
    drinks_menu = state |> Map.fetch!(:drinks_menu)
  
    # reduce the state using the values of the verbs
    # in the drinks_menu
    verbs
    |> List.wrap
    |> Enum.reduce(state,
    fn verb, state ->
  
      # must find the verb in the drinks_menu
      case drinks_menu |> Map.fetch!(verb) do
  
        # is the verb's value a MFA 3tuple?
        # note: the fun_name will always be make_drink in this example
        # but the code works for any fun_name
        {module, fun_name, mfa_args} ->
  
          # create the complete arguments list
          all_args = [state] ++ mfa_args ++ [opts]
  
          # run the function
          apply(module, fun_name, all_args)
  
        # is the verb's value a fun?
        fun when is_function(fun, 1) -> fun.(state)
        fun when is_function(fun, 2) -> fun.(state, opts)
          
        # no default => error
          
      end
  
    end)
  
  end

  defmacro __using__(_opts \\  []) do

    quote do
      
      # register the @on_definition callback for the calling module (e.g.
      # CoffeeMaker) to this's module make_drink_on_def_callback function
      @on_definition {DrinkMaker.Menu, :make_drink_on_def_callback}
      
      # register the drinks_menu attribute with the persistent option
      Module.register_attribute(__MODULE__, :drinks_menu, persist: true)
      
      # initialize the drinks_menu
      Module.put_attribute(__MODULE__, :drinks_menu, %{})

    end
    
  end

end
