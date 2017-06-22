defmodule Steemex.Stage.StructuredOps do
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("StructuredOps stage is initializing...")
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    structured_events = Enum.map(events,
      fn ev -> Map.update!(ev, :data, &Steemex.Ops.Transform.prepare_for_db/1) end
    )
    {:noreply, structured_events, number}
  end

end
