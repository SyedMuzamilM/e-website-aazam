defmodule Rath.Queries.Roles do
  import Ecto.Query, warn: false

  alias Rath.Schemas.Role

  def start() do
    from(r in Role)
  end

  def filter_by_role_id(query, role_id) do
    where(query, [r], r.id == ^role_id)
  end

  def filter_by_role_name(query, role_name) do
    where(query, [r], r.name == ^role_name)
  end
end
