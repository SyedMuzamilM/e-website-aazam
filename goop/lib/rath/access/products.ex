defmodule Rath.Access.Products do
  import Ecto.Query, warn: false

  alias Rath.Repo
  alias Rath.Schemas.Product
  alias Rath.Queries.Products, as: Query

  def get(product_id) do
    Repo.get(Product, product_id)
  end

  def get_all() do
    Query.start()
    |> select([p], p)
    |> Query.product_category()
    |> Query.product_inventory()
    |> Repo.all()
  end

  def get_product_details(product_id) do
    Query.start()
    |> Query.filter_by_id(product_id)
    |> select([p], p)
    |> Query.product_category()
    |> Query.product_inventory()
    |> Query.product_discount()
    |> Query.limit_one()
    |> Repo.one()
  end
end
