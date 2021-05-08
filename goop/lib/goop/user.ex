defmodule Goop.User do
  alias Rath.Users

  def delete(user_id) do
    Users.delete(user_id)
  end
end
