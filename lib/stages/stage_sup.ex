defmodule Steemex.Stage.Supervisor do
  use Supervisor
  alias Steemex.Stage
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: Steemex.Stage.Supervisor)
  end

  def init(:ok) do
    Logger.info("Stage Supervisor is initializing...")
    blocks_producer = Steemex.Stage.Blocks
    stage_ops_prod_cons = Steemex.Stage.Ops
    stage_structured_ops_prod_cons = Steemex.Stage.StructuredOps
    children = [
      worker( blocks_producer, [[], [name: blocks_producer] ] ),
      worker( stage_ops_prod_cons, [[subscribe_to: [blocks_producer]], [name: stage_ops_prod_cons] ] ),
      worker( stage_structured_ops_prod_cons, [[subscribe_to: [stage_ops_prod_cons]], [name: stage_structured_ops_prod_cons] ] ),
      worker( Stage.StructuredOps.ExampleConsumer, [[subscribe_to: [stage_structured_ops_prod_cons]]]),
    ]
    supervise(children, strategy: :one_for_all)
  end


end
