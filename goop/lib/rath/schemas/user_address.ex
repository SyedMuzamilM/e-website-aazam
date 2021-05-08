defmodule Rath.Schemas.UserAddress do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :user, :address_line_1, :address_line_2, :district, :mobile]}

  @primary_key {:id, :binary_id, []}
  schema "user_address" do
    field(:address_line_1, :string)
    field(:address_line_2, :string)
    field(:district, :string)
    field(:post_code, :string)
    field(:telephone, :string)
    field(:mobile, :string)

    belongs_to(:user, Rath.Schemas.User, foreign_key: :user_id, type: :binary_id)

    timestamps()
  end

  def changeset(user_address, _attrs) do
    user_address
    |> validate_required([:address_line_1, :address_line_2, :district, :mobile])
  end
end
