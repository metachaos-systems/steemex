defmodule Steemex.Ops.AccountCreate do
  @enforce_keys [:active, :json_metadata, :memo_key, :new_account_name, :owner, :posting]
  defstruct [:active, :json_metadata, :memo_key, :new_account_name, :owner, :posting]
end
