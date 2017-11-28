defmodule Steemex.Supervisor do
  require Logger
  alias Steemex.StageSupervisor
  @default_ws_url "wss://steemd-int.steemit.com/"

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec
    Logger.info("#{__MODULE__} is being initialized...")
    url = Application.get_env(:steemex, :url) || @default_ws_url
    Logger.info("Steemex WS url is set to #{url}")
    activate_stage_sup? = Application.get_env(:steemex, :activate_stage_sup)
    activate_ws_processes? = Application.get_env(:steemex, :activate_ws_processes)
    stages = if activate_stage_sup?, do: [supervisor(StageSupervisor, [])], else: []

    ws_processes =
      if activate_ws_processes? do
        [
          worker(Steemex.IdStore, []),
          worker(Steemex.WS, [url])
        ]
      else
        []
      end

    children = ws_processes ++ stages

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

end
