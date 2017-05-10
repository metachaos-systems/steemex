defmodule Steemex.Stage.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: Steemex.Stage.Supervisor)
  end

  def init(:ok) do
    children = [
      worker(
        Steemex.Stage.Blocks.Producer, [[], [name: Steemex.Stage.Blocks.Producer] ]
      ),
      worker(
        Steemex.Stage.Ops.ProducerConsumer, [%{subscribe_to: [Steemex.Stage.Blocks.Producer]}, [name: Steemex.Stage.Ops.ProducerConsumer] ]
      ),
    ]
    supervise(children, strategy: :one_for_all)
  end


end
