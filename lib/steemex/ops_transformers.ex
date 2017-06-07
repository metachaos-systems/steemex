defmodule Steemex.Ops.Transform do
  alias Steemex.Ops.{Transfer}

  def prepare_for_db(%Transfer{} = op) do
    {int, remaining_token_string} = Float.parse(op.amount)
    token = cond do
      String.match?(remaining_token_string, ~r"SBD") -> "SBD"
      String.match?(remaining_token_string, ~r"STEEM") -> "STEEM"
    end
    %{amount: int, to: op.to, from: op.from, token: token, memo: op.memo}
  end

  def prepare_for_db(op), do: op

end
