defmodule Steemex.StructuredStage.Ops.ExampleConsumer do
  use GenStage
  alias Steemex.StructuredOps
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      process_event(op)
    end
    {:noreply, [], state}
  end

  def process_event({%StructuredOps.Reblog{} = op_data, %{height: h, timestamp: t} =  op_metadata}) do
      Logger.info """
      New reblog:
      #{inspect op_data} at height #{h} and time #{t}
      """
  end

  def process_event({op_data, %{height: h, timestamp: t} =  op_metadata}) do
      Logger.info """
      New operation:
      #{inspect op_data} at height #{h} and time #{t}
      """
  end

end
