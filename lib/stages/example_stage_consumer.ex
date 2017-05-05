defmodule Steemex.Stage.Ops.ExampleConsumer do
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:consumer, state, subscribe_to: state.subscribe_to}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      Logger.info """
      New operation:
      #{inspect op}
      """
    end
    {:noreply, [], state}
  end

end
