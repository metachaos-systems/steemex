defmodule Steemex.Ops.Transform do
  alias Steemex.Ops.{Transfer, TransferToVesting,Comment, CustomJson, FeedPublish}

  def prepare_for_db(%Transfer{} = op) do
    parsed = %{token: _, amount: _} =
      op.amount
      |> parse_steemlike_token_amount()

    op
      |> Map.delete(:__struct__)
      |> Map.merge(parsed)
  end

  def prepare_for_db(%Comment{} = op) do
    op
      |> Map.delete(:__struct__)
      |> Map.update!(:json_metadata, &Poison.Parser.parse!(&1))
      |> Map.update!(:title, &(if &1 == "", do: nil, else: &1))
      |> Map.update!(:parent_author, &(if &1 == "", do: nil, else: &1))
      |> AtomicMap.convert(safe: false)
      |> (&Map.put(&1, :tags, &1.json_metadata.tags)).()
      |> (&Map.put(&1, :app, &1.json_metadata.app)).()
  end

  def prepare_for_db(%TransferToVesting{} = op) do
    parsed = %{token: _, amount: _} =
      op.amount
      |> parse_steemlike_token_amount()

    op
      |> Map.delete(:__struct__)
      |> Map.merge(parsed)
  end


  def prepare_for_db(%FeedPublish{exchange_rate: %{base: base, quote: quote}} = op) do
    base = base |> parse_steemlike_token_amount()
    quote = quote |> parse_steemlike_token_amount()

    op
      |> Map.from_struct
      |> Map.delete(:exchange_rate)
      |> Map.merge(%{base_amount: base.amount, base_token: base.token })
      |> Map.merge(%{quote_amount: quote.amount, quote_token: quote.token})
  end

  def prepare_for_db(%CustomJson{json: json} = op) when is_binary(json) do
    prepare_for_db(%{op | json: Poison.Parser.parse!(json)})
  end

  def prepare_for_db(%CustomJson{id: id, json: [op_name, op_data]})
   when id == "follow" and op_name == "follow" do
    op_data
      |> AtomicMap.convert(safe: false)
  end

  def prepare_for_db(%CustomJson{id: id, json: [op_name, op_data]})
   when id == "follow" and op_name == "reblog" do
    op_data
      |> AtomicMap.convert(safe: false)
  end

  def prepare_for_db(op), do: op

  def parse_steemlike_token_amount(binary) do
    {int, remaining_token_string} = Float.parse(binary)
    token = cond do
      String.match?(remaining_token_string, ~r"SBD") -> "SBD"
      String.match?(remaining_token_string, ~r"STEEM") -> "STEEM"
    end
    %{token: token, amount: int}
  end

end
