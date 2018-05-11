defmodule Steemex.Supervisor do
  require Logger
  alias Steemex.StageSupervisor
  @default_api :steemit_api

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec
    Logger.info("#{__MODULE__} is being initialized...")
    api = Application.get_env(:steemex, :api) || @default_api
    activate_stage_sup? = Application.get_env(:steemex, :activate_stage_sup)
    stages = if activate_stage_sup?, do: [supervisor(StageSupervisor, [])], else: []

    processes =
      case api do
        :jsonrpc_ws_api ->
          url = Application.get_env(:steemex, :api_url)
          if is_nil(url), do: throw("Steemex: websockets JSONRPC api URL is NOT configured!")
          Logger.info("Steemex webscokets JSONRPC api URL is set to #{url}")

          [
            worker(Steemex.IdStore, []),
            worker(Steemex.WS, [url])
          ]

        _ ->
          []
      end

    children = processes ++ stages

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end
end
