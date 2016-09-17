defmodule Steemex do
  use Application
  alias Steemex.IdAgent
  @db_api "database_api"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    handler_mod = Application.get_env(:steemex, :handler)
    url = Application.get_env(:steemex, :url)

    unless is_function(&handler_mod.handle_jsonrpc_call/3), do: throw("Handler module handle_jsonrpc_call is NOT a function")
    unless handler_mod, do: throw("Steemex Handler module is NOT configured.")
    unless url, do: throw("Steemex WS url is NOT configured.")

    children = [
      worker(IdAgent, []),
      worker(Steemex.WS, [&handler_mod.handle_jsonrpc_call/3, url])
    ]
    opts = [strategy: :one_for_one, name: Steemex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def call(params) do
     id = gen_id()
     IdAgent.put(id, {params, nil})
     send_jsonrpc_call(id, params)
  end

  def call_sync(params) do
    # implementation for blocking call goes here, most probably simply by using receive
    id = gen_id()
    IdAgent.put(id, {params, self()})

    send_jsonrpc_call(id, params)

    response_data = receive do
      {:response, {id, params, data}} -> data
    end

    case response_data["error"] do
      nil -> {:ok, response_data}
      _ -> {:error, response_data}
    end
  end

  def get_block(height) do
    Steemex.call [@db_api, "get_block", [height]]
  end

  def get_content(author, permlink) do
    Steemex.call [@db_api, "get_content", [author, permlink]]
  end

  def get_accounts_sync(accounts) do
    accounts = List.wrap(accounts)
    case call_sync([@db_api, "get_accounts", [accounts]]) do
       {:ok, data} ->  {:ok, data["result"]}
       {:error, err} -> {:error, err}
    end
  end


  @doc """
  Sends an event to the WebSocket server
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

  defp send_jsonrpc_call(id, params) do
    send_event Steemex.WS, %{jsonrpc: "2.0", id: id, params: params, method: "call"}
  end

  defp gen_id do
    round(:rand.uniform * 1.0e16)
  end

end
