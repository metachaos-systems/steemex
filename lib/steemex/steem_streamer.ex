defmodule Steemex.Streamer do
  use GenServer
  require Logger
  @tick_interval 1_500

  @doc """
  Starts the handler module
  """
  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    {:ok, %{"head_block_number" => last_height}} = Steemex.get_dynamic_global_properties
    Process.send_after(self(), :tick, @tick_interval)
    {:ok, %{last_height: last_height, stream_to: config.stream_to}}
  end

  def handle_info(:tick, state) do
    {:ok, data} = Steemex.get_block(state.last_height)
    state = if data do
      for t <- unpack_and_convert_operations(data), do: Process.send(state.stream_to, t, [])
      put_in(state.last_height, state.last_height + 1)
    else
      state
    end
    Process.send_after(self(), :tick, @tick_interval)
    {:noreply, state}
  end

  def unpack_and_convert_operations(block) do
     for tx <- block["transactions"] do
      for op <- tx["operations"] do
        convert_to_tuple(op)
      end
     end
     |> List.flatten
  end

  def convert_to_tuple(op = [op_type, op_data]) do
    parse_json_strings = fn x, key ->
      val = x[key] || "{}"
      case Poison.Parser.parse(val) do
         {:ok, map} -> put_in(x, [key], map)
         {:error, _} -> %{}
      end
    end
    op_data = op_data
      |> AtomicMap.convert(safe: false)
      |> parse_json_strings.(:json)
      |> parse_json_strings.(:json_metadata)

    op_struct = select_struct(op_type)
    op_data = if op_struct, do: struct(op_struct,op_data), else: op_data
    {String.to_atom(op_type), op_data}
  end


  def select_struct(op_type) do
    alias Steemex.Ops.{Comment, Vote, CustomJson, POW2, CommentOptions,
      FeedPublish, Transfer, AccountCreate,TransferToVesting, LimitOrderCreate, LimitOrderCancel}
    case op_type do
      "comment" -> Comment
      "vote" -> Vote
      "custom_json" -> CustomJson
      "pow2" -> POW2
      "feed_publish" -> FeedPublish
      "transfer" -> Transfer
      "account_create" -> AccountCreate
      "transfer_to_vesting" -> TransferToVesting
      "limit_order_create" -> LimitOrderCreate
      "limit_order_cancel" -> LimitOrderCancel
      "comment_options" -> CommentOptions
      _ ->
        Logger.info("Steemex.Streamer encountered unknown op_type: #{op_type}")
        nil
    end
  end
end
