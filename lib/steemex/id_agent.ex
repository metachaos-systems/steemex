defmodule Steemex.IdAgent do

  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def get(id) do
    Agent.get_and_update(__MODULE__, fn map ->
      map |> Map.pop(String.to_integer(id))
    end)
  end

  def put(id, params) do
    Agent.update(__MODULE__, fn map ->
      Map.put(map, id, params)
    end)
  end

end
