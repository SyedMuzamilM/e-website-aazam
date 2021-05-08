defmodule Rath.Queries.Users do
  import Ecto.Query

  alias Rath.Schemas.User
  alias Rath.Schemas.Role

  def start do
    from(u in User)
  end

  def limit_one(query) do
    limit(query, [], 1)
  end

  def select_id(query) do
    select(query, [u], u.id)
  end

  def filter_by_id(query, user_id) do
    where(query, [u], u.id == ^user_id)
  end

  def filter_by_google_id(query, google_id) do
    where(query, [u], u.google_id == ^google_id)
  end

  def filter_by_google_ids(query, github_ids) do
    where(query, [u], u.googleId in ^github_ids)
  end

  def role_info(query) do
    query
    |> join(:left, [u], r in Role,
      as: :role_name,
      on: u.role_id == r.id
    )
    |> select_merge([role_name: r], %{
      role_name: r.name
    })
  end

  def update_set_role(query, role_id) do
    update(query,
      set: [
        role_id: ^role_id
      ]
    )
  end

  # Not created yet
  def set_cart_items(query, cart_items) do
    update(query,
      set: [
        cart_items: ^cart_items
      ]
    )
  end
end
