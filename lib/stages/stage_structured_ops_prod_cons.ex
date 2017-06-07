defmodule Steemex.Stage.StructuredOps.ProducerConsumer do
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    structured_events = for {_op_type, op_data, op_metadata} <- events do
       {Steemex.Ops.Transform.prepare_for_db(op_data), op_metadata}
     end
    {:noreply, structured_events, number}
  end

end
