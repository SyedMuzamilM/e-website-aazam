defmodule Rath.Access.Roles do
  import Ecto.Query, warn: false

  alias Rath.Repo
  alias Rath.Schemas.Role
  alias Rath.Queries.Roles, as: Query

  def get_all_roles() do
    Repo.all(Role)
  end

  def get_all_user_by_roles(role_id) do
    query =
      Query.start()
      |> Query.filter_by_role_id(role_id)

    Repo.all(query)
  end

  def get_role_by_id(role_id) do
    Repo.get(Role, role_id)
  end

  def get_role_id_from_name(role_name) do
    Query.start()
    |> Query.filter_by_role_name(role_name)
    |> Repo.one()
  end
end
