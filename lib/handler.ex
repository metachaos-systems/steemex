defmodule Steemex.Handler do
  use GenServer
  require Logger

  # API
  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # SERVER
  def handle_info({:ws_response, {id, ["database_api", "get_dynamic_global_properties", []], data}}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_info({:ws_response, {id, ["database_api", "get_state", params], data}}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_info(msga = {:ws_response, {id, msg, data}}, _) do
    Logger.debug("No known handler function for this message")
    Logger.debug inspect(msga)
    {:noreply, []}
  end

end
