defmodule SteemexHandler do
  use GenServer
  require Logger

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  def handle_info({["database_api", "get_dynamic_global_properties", []], data}, _) do
    IO.inspect("dynamic global properties pattern matched")
    IO.inspect(data)
    {:noreply, []}
  end

  def handle_info(msg, _) do
    IO.puts("No handler function for this message")
    IO.inspect(msg)
    {:noreply, []}
  end

  def handle_info(anything, state) do
    IO.puts("anything")
    IO.inspect anything
    {:noreply, state}
  end


end
