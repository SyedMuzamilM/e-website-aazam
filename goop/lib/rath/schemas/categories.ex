defmodule Rath.Schemas.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name]}

  @primary_key {:id, :binary_id, []}
  schema "categories" do
    field(:name, :string)
    field(:description, :string)
    timestamps()
  end

  def changeset(category, _attrs) do
    category
    |> validate_required([:name, :description])
  end
end
