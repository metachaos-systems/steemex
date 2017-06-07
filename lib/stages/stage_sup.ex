defmodule Steemex.Stage.Supervisor do
  use Supervisor
  alias Steemex.Stage
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: Steemex.Stage.Supervisor)
  end

  def init(:ok) do
    blocks_producer = Stage.Blocks.Producer
    children = [
      worker( Stage.Blocks.Producer, [[], [name: blocks_producer] ] ),
      worker( Stage.Ops.ProducerConsumer, [%{subscribe_to: [blocks_producer]}, [name: Stage.Ops.ProducerConsumer] ] ),
      # worker( Stage.Ops.ExampleConsumer, [%{subscribe_to: [Stage.Ops.ProducerConsumer]}])
    ]
    supervise(children, strategy: :one_for_all)
  end


end
