defmodule CsvReader.Model.OracleBatchBlock do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :float, []}
  schema "prn_batch_block" do
  end

  def changeset(batch_block, attrs) do
    batch_block
    |> cast(attrs, [:username, :status, :campus_code, :division_code])
  end
end
