defmodule Rath.Roles do
  defdelegate get_all_roles(), to: Rath.Access.Roles
  defdelegate get_role_id_from_name(role_name), to: Rath.Access.Roles
  defdelegate get_role_by_id(role_id), to: Rath.Access.Roles
end
