defmodule SteemexHandler do
  use GenServer
  require Logger

  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_jsonrpc_call(id, call_params, data) do
    GenServer.cast(__MODULE__, {id, call_params, data} )
  end

  def handle_cast({id, ["database_api", "get_dynamic_global_properties", []], data}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_cast({id, ["database_api", "get_state", params], data}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_cast({id, msg, data}, _) do
    Logger.debug("No known handler function for this message")
    Logger.debug inspect(msg)
    {:noreply, []}
  end


end
