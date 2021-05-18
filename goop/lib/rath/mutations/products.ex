defmodule Rath.Mutations.Products do
  # import Ecto.Query

  alias Rath.Repo
  alias Rath.Schemas.Product
  # alias Rath.Queries.Users, as: Query

  def create_product(data) do
    {:create,
     Repo.insert!(%Product{
       pr_name: data["pr_name"],
       pr_slug: data["pr_slug"],
       original_price: String.to_integer(data["original_price"]),
       sales_price: String.to_integer(data["sales_price"])
     })}
  end
end
