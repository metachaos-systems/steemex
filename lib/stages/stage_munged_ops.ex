defmodule Steemex.Stage.MungedOps do
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Steemex MungedOps stage is initializing...")
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    structured_events = Enum.map(
      events,
      fn ev ->
        ev
        |> Map.update!(:data, &Steemex.Ops.Munger.parse/1)
        |> mark_if_munged
     end
    )


    {:noreply, structured_events, number}
  end

  def mark_if_munged(ev) do
    munged_ops_struct = Map.get(ev.data, :__struct__) |> Atom.to_string() |> String.downcase |> String.contains?("munged")
    if munged_ops_struct do
      new_metadata = Map.put(ev.metadata, :munged, :true)
      Map.put(ev, :metadata, new_metadata)
    else
      ev
    end
  end
end
