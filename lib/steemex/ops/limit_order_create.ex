defmodule Steemex.Ops.LimitOrderCreate do
  @enforce_keys [:amount_to_sell, :expiration, :fill_or_kill, :min_to_receive, :orderid, :owner]
  defstruct [:amount_to_sell, :expiration, :fill_or_kill, :min_to_receive, :orderid, :owner]

end
