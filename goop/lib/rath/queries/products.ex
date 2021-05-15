defmodule Rath.Queries.Products do
  import Ecto.Query

  alias Rath.Schemas.Product
  alias Rath.Schemas.Category
  alias Rath.Schemas.Inventory
  alias Rath.Schemas.Discount

  def start do
    from(p in Product)
  end

  def limit_one(query) do
    where(query, [], 1)
  end

  def select_id(query) do
    where(query, [p], p.id)
  end

  def filter_by_id(query, product_id) do
    where(query, [p], p.id == ^product_id)
  end

  def product_category(query) do
    query
    |> join(:left, [p], c in Category,
      as: :category,
      on: p.category_id == c.id
    )
    |> select_merge([category: c], %{
      category: c.name
    })
  end

  def product_inventory(query) do
    query
    |> join(:left, [p], i in Inventory,
      as: :total_items,
      on: p.inventory_id == i.id
    )
    |> select_merge([total_items: i], %{
      total_items: i.quantity
    })
  end

  def product_discount(query) do
    query
    |> join(:left, [p], d in Discount,
      as: :discount_price,
      on: p.discount_id == d.id
    )
    |> select_merge([discount_price: d], %{
      discount_price: d.discount_amout
    })
  end
end
