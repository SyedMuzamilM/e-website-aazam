defmodule Rath.Access.Users do
  import Ecto.Query, warn: false

  alias Rath.Repo
  alias Rath.Schemas.User
  alias Rath.Queries.Users, as: Query

  def get(user_id) do
    Repo.get(User, user_id)
  end

  def get_by_id_with_role(user_id) do
    Query.start()
    |> Query.filter_by_id(user_id)
    |> select([u], u)
    |> Query.role_info()
    |> Query.limit_one()
    |> Repo.one()
  end

  def get_by_google_id(google_id) do
    Query.start()
    |> Query.filter_by_google_id(google_id)
    |> Repo.one()
  end
end
