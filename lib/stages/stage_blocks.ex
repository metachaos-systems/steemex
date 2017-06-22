defmodule Steemex.Stage.Blocks do
  @moduledoc """
  Produces Golos block data with @tick_interval
  """
  @tick_interval 1_000
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state)  do
    Logger.info("Steemex Blocks Stage is initializing...")
    :timer.send_interval(@tick_interval, :tick)
    state = if state === [], do: %{}
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info(:tick, state) do
    {:ok, %{head_block_number: height}} = Steemex.get_dynamic_global_properties()
    previous_height = Map.get(state, :previous_height, nil)
    {events, state} = if height === previous_height do
      {[], state}
    else
      {:ok, block} = Steemex.get_block(height)
      if block do
        block = Map.put(block, :height, height)
        new_state = Map.put(state, :previous_height, height)
        {[block], new_state}
      else
        {[block], state}
      end
    end
    {:noreply, events, state}
  end

end
