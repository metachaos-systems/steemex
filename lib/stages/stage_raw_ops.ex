defmodule Steemex.Stage.RawOps do
  use GenStage
  require Logger

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Steemex Ops Stage is initializing...")
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    events = for block <- events, do: unpack_and_convert_operations(block)
    {:noreply, List.flatten(events), number}
  end

  def unpack_and_convert_operations(%Steemex.Event{data: block}) do
     for tx <- block.transactions do
      for op <- tx.operations do
        convert_to_event(op, block)
      end
     end
  end

  def convert_to_event(op = [op_type, op_data], block) do
    parse_json_strings = fn x, key ->
      val = x[key] || "{}"
      case Poison.Parser.parse(val) do
         {:ok, map} -> put_in(x, [key], map)
         {:error, _} -> %{}
      end
    end
    op_data = op_data
      |> AtomicMap.convert(safe: false, underscore: false)
      |> parse_json_strings.(:json)
      |> parse_json_strings.(:json_metadata)

    op_struct = select_struct(op_type)
    op_data = if op_struct, do: struct(op_struct, op_data), else: op_data
    metadata = %{
      block_height: block.height,
      timestamp: block.timestamp,
      source: :steem,
      type: String.to_atom(op_type),
      munged: false}
    %Steemex.Event{data: op_data, metadata: metadata}
  end

  def select_struct(op_type) do
    alias Steemex.Ops.{Comment, Vote, CustomJson, POW2, CommentOptions,
      FeedPublish, Transfer, AccountCreate, TransferToVesting, LimitOrderCreate, LimitOrderCancel}
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
        # Logger.info("Steemex Ops ProducerConsumer encountered unknown op_type: #{op_type}")
        nil
    end
  end

end
