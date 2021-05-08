defmodule Rath.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :avatar_url, :role_name, :full_address]}

  @primary_key {:id, :binary_id, []}
  schema "users" do
    field(:google_id, :string)
    field(:google_access_token, :string)
    field(:google_refresh_token, :string)
    field(:token_version, :integer)
    field(:name, :string)
    field(:email, :string)
    field(:avatar_url, :string)
    field(:role_name, :string, virtual: true)
    field(:full_address, :string, virtual: true)

    # Add the cartitems field here
    # Add the user_adress field

    belongs_to(:role, Rath.Schemas.Role, foreign_key: :role_id, type: :binary_id)
    belongs_to(:address, Rath.Schemas.UserAddress, foreign_key: :address_id, type: :binary_id)

    timestamps()
  end

  def changeset(user, _attrs) do
    user
    |> validate_required([:google_id, :avatar_url])
  end
end
