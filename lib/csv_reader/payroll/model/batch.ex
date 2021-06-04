defmodule CsvReader.Model.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  alias CsvReader.Model.BatchBlock

  @states ["ACTIVE", "INACTIVE"]

  schema "batch" do
    field :username, :string
    field :status, :string
    field :calendar_id, :integer
    timestamps()
    has_many :batch_block, BatchBlock
  end

  def changeset(batch, attrs) do
    batch
    |> cast(attrs, [:username, :status, :calendar_id])
    |> validate_required([:username])
    |> validate_inclusion(:status, @states)
  end
end
