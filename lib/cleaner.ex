defmodule Steemex.Cleaner do

  def strip_token_names_and_convert_to_number(data) do
    to_clean = ~w(max_accepted_payout promoted total_payout_value pending_payout_value total_pending_payout_value
    curator_payout_value promoted balance vesting_withdraw_rate
    savings_balance savings_sbd_balance sbd_balance vesting_balance vesting_shares)a
    for {k,v} <- data, into: %{} do
       {k, (if k in to_clean, do: v |> Float.parse |> elem(0), else: v)}
    end
  end

  def prepare_tags(data) do
    update_in(data.tags, &List.wrap/1)
  end


end
