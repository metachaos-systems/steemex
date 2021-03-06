defmodule Steemex.Stage.Blocks do
  @moduledoc """
  Produces Steem blocks, check for new blcoks with tick_interval
  """
  @tick_interval 1_000
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Steemex Blocks Stage is initializing...")
    :timer.send_interval(@tick_interval, :tick)
    state = if state === [], do: %{}
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info(:tick, state) do
    previous_height = Map.get(state, :previous_height, nil)

    height =
      with {:ok, glob_props} <- Steemex.get_dynamic_global_properties() do
        glob_props.head_block_number
      else
        _ -> previous_height
      end

    if height === previous_height do
      {:noreply, [], state}
    else
      with {:ok, block} <- Steemex.get_block(height) do
        case block do
          %Steemex.Block{} ->
            block = Map.put(block, :height, height)
            new_state = Map.put(state, :previous_height, height)
            meta = %{source: :naive_realtime, type: :block}
            events = [%Steemex.Event{data: block, metadata: meta}]
            {:noreply, events, new_state}

          nil ->
            {:noreply, [], state}
        end
      else
        _err -> {:noreply, [], state}
      end
    end
  end
end
