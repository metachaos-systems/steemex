defmodule Steemex do
  use Application

  def start_link do
    import Supervisor.Spec, warn: false
     children = [
       worker(Steemex.WsHandler, [])
     ]
     opts = [strategy: :one_for_one, name: Steemex.Supervisor]
     Supervisor.start_link(children, opts)
  end

end
