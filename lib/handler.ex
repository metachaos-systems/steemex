defmodule SteemexHandler do
  use GenServer
  require Logger

  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [])
  end

  def handle_info({["database_api", "get_dynamic_global_properties", []], data}, _) do
    IO.inspect(data)
    {:noreply, []}
  end

  def handle_info({msg_name, _}, _) do
    Logger.warn("No known handler function for this message #{msg_name}")
    {:noreply, []}
  end


end
