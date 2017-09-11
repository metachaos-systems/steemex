defmodule Steemex.Cleaner do

  def strip_token_names_and_convert_to_number(data) do
    to_clean = ~w(max_accepted_payout promoted total_payout_value pending_payout_value total_pending_payout_value
    curator_payout_value promoted balance vesting_withdraw_rate
    savings_balance savings_sbd_balance sbd_balance vesting_balance vesting_shares)a
    for {k,v} <- data, into: %{} do
       {k, (if k in to_clean, do: v |> Float.parse |> elem(0), else: v)}
    end
  end

  def parse_empty_strings(data) do
    data
      |> Map.update!(:parent_author, &(if &1 == "", do: nil, else: &1) )
      |> Map.update!(:author, &(if &1 == "", do: nil, else: &1))
      |> Map.update!(:permlink, &(if &1 == "", do: nil, else: &1))
  end
  
  def parse_timedate_strings(data) do
    to_parse = ~w(created last_payout cashout_time max_cashout_time active last_update)a
    for {k, v} <- data, into: %{} do
       {k, (if k in to_parse, do: NaiveDateTime.from_iso8601!(v), else: v)}
    end
  end

  def prepare_tags(data) do
    update_in(data.tags, &List.wrap/1)
  end

  def parse_json_strings(x, key) do
      if is_map(x[key]) do
        x
      else
        val = x[key] || "{}"
        case Poison.Parser.parse(val) do
           {:ok, map} -> put_in(x, [key], map)
           {:error, _} -> put_in(x, [key], %{})
        end
      end
  end

  def extract_fields(data = %{json_metadata: ""}) do
    data
    |> Map.put(:json_metadata, %{})
    |> Map.put(:tags, [])
    |> Map.put(:tags, nil)
  end

  def extract_fields(data) do
    data
      |> (&Map.put(&1, :tags, &1.json_metadata[:tags] || [])).()
      |> (&Map.put(&1, :app, &1.json_metadata[:app] || nil)).()
  end

end
