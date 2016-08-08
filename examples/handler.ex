defmodule SteemexHandler do
  use GenServer
  require Logger

  def start_link([]) do
     {:ok, []}
  end

  def handle_info({:get_dynamic_global_properties, [], data}, _) do
    IO.inspect(data)
  end

  def handle_info({:get_content, [author, permalink], data}, _) do
    IO.inspect(data)
  end

  def handle_info({msg_name, _}, _) do
    Logger.warn("No handler function for this message #{msg_name}")
  end


end
