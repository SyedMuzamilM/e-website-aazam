defmodule Rath.Users do
  @moduledoc """
  Context module for Users. This module acts as a "gateway" module defining
  the "boundary" for Users database access.
  """

  # ACCESS functions
  defdelegate get(user_id), to: Rath.Access.Users

  defdelegate get_by_id_with_role(user_id), to: Rath.Access.Users
  defdelegate get_by_google_id(google_id), to: Rath.Access.Users
  ############################################################################
  # MUTATIONS
  defdelegate update(changeset), to: Rath.Repo

  defdelegate delete(user_id), to: Rath.Mutations.Users
end
