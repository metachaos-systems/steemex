defmodule Steemex.Stage.Blocks.Producer do
  @moduledoc """
  Produces Golos block data with @tick_interval
  """
  @tick_interval 1_000
  use GenStage

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state)  do
    :timer.send_interval(@tick_interval, :tick)
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info(:tick, state) do
    {:ok, %{"head_block_number" => height}} = Steemex.get_dynamic_global_properties()
    if height === state[:previous_height] do
      {:noreply, [], state}
    else
      {:ok, block} = Steemex.get_block(height)
      if block do
        block = put_in(block, ["height"], height)
        state = put_in(state, [:previous_height], height)
        {:noreply, [block], state}
      else
        {:noreply, [], state}
      end
    end
  end
end
