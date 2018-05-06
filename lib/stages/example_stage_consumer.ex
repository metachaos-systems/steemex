defmodule Steemex.Stage.ExampleConsumer do
  @moduledoc """
  An example of GenStage event consumer
  """
  use GenStage
  alias Steemex.MungedOps
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Example consumer is initializing...")
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      process_event(op)
    end
    {:noreply, [], state}
  end

  def process_event(%{data: %MungedOps.Reblog{} = data, metadata: %{height: h, timestamp: t} = metadata}) do
      Logger.info """
      New reblog:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

  def process_event(%{data: data, metadata: %{block_height: h, timestamp: t} = metadata}) do
      Logger.info """
      New operation:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

end
