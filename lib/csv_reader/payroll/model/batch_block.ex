defmodule CsvReader.Model.BatchBlock do
  use Ecto.Schema
  import Ecto.Changeset

  alias CsvReader.Model.Batch
  alias CsvReader.Model.Paysheet

  schema "batch_block" do
    field :username, :string
    field :status, :string
    field :campus_code, :string
    field :division_code, :string
    timestamps()
    belongs_to :batch, Batch
    has_many :paysheets, Paysheet
  end

  def changeset(batch_block, attrs) do
    batch_block
    |> cast(attrs, [:username, :status, :campus_code, :division_code])
  end
end
