defmodule Rath.Schemas.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name]}

  @primary_key {:id, :binary_id, []}
  schema "roles" do
    field(:name, :string)

    timestamps()
  end

  def changeset(role, _attrs) do
    role
    |> validate_required([:name])
  end
end
