defmodule Steemex.Block do
  defstruct [:height, :previous, :extensions, :timestamp, :transaction_merkle_root, :transactions, :witness, :witness_signature]

  use ExConstructor

  def parse_raw_data(block) do
    Map.put(block, :timestamp, block.timestamp <> "Z" |> NaiveDateTime.from_iso8601!())
  end
end
