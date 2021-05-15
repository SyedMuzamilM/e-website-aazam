defmodule Rath.Schemas.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :pr_name,
             :pr_slug,
             :sales_price,
             :category,
             :total_items,
             :discount_price
           ]}

  @primary_key {:id, :binary_id, []}
  schema "products" do
    field(:pr_name, :string)
    field(:pr_slug, :string)
    field(:original_price, :integer)
    field(:sales_price, :integer)

    # virtual fields
    field(:category, :string, virtual: true)
    field(:total_items, :integer, virtual: true)
    field(:discount_price, :integer, virtual: true)

    # relations
    belongs_to(:categories, Rath.Schemas.Category, foreign_key: :category_id, type: :binary_id)
    belongs_to(:inventories, Rath.Schemas.Inventory, foreign_key: :inventory_id, type: :binary_id)
    belongs_to(:discounts, Rath.Schemas.Discount, foreign_key: :discount_id, type: :binary_id)

    timestamps()
  end

  def changeset(product, _attrs) do
    product
    |> validate_required([:pr_name, :sales_price])
  end
end
