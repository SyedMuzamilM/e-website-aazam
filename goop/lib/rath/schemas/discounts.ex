defmodule Rath.Schemas.Discount do
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:id, :discount_name, :discount_amount, :active]}

  @primary_key {:id, :binary_id, []}
  schema "discounts" do
    field(:discount_name, :string)
    field(:discount_desc, :string)
    field(:discount_amout, :integer)
    field(:active, :boolean)
    timestamps()
  end
end
