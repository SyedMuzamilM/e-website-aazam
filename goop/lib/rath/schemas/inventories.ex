defmodule Rath.Schemas.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :quantity]}

  @primary_key {:id, :binary_id, []}
  schema "inventories" do
    field(:quantity, :integer)
    timestamps()
  end

  def changeset(inventory, _attrs) do
    inventory
    |> validate_required([:quantity])
  end
end
