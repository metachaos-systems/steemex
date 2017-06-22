defmodule Steemex.Block do
  defstruct [:height, :previous, :extensions, :timestamp, :transaction_merkle_root, :transactions, :witness, :witness_signature]

  use ExConstructor
end
