defmodule Steemex.Block do
  defstruct [:height, :transactions, :previous, :transactions_merkle_root, :witness, :witness_signature, :timestamp, :extensions]
end
