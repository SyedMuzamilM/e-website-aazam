defmodule Rath.Mutations.Users do
  import Ecto.Query

  alias Rath.Repo
  alias Rath.Schemas.User
  alias Rath.Queries.Users, as: Query

  def delete(user_id) do
    %User{id: user_id} |> Repo.delete()
  end

  def set_role(user_id, role_id) do
    Query.start()
    |> Query.filter_by_id(user_id)
    |> Query.update_set_role(role_id)
    |> Repo.update_all([])
  end

  def set_current_cart_items(user_id, cart_items \\ []) do
    Query.start()
    |> Query.filter_by_id(user_id)
    |> Query.set_cart_items(cart_items)
    |> Repo.update_all([])
  end

  def google_find_or_create(user, google_access_token, google_refresh_token) do
    # google_id = Integer.to_string(user["id"])
    # email = user["email"]
    google_id = user["id"]

    db_user =
      from(u in User,
        where: u.google_id == ^google_id,
        limit: 1
      )
      |> Repo.one()

    user_count = Repo.one(from(u in User, select: count(u.id)))

    user_role_id = Rath.Access.Roles.get_role_id_from_name("user").id
    admin_role_id = Rath.Access.Roles.get_role_id_from_name("admin").id

    role_id =
      if(user_count == 0) do
        admin_role_id
      else
        user_role_id
      end

    if db_user do
      if is_nil(db_user.google_access_token) do
        from(u in User,
          where: u.id == ^db_user.id,
          update: [
            set: [
              google_access_token: ^google_access_token,
              google_refrsh_token: ^google_refresh_token
            ]
          ]
        )
        |> Repo.update_all([])
      end

      {:find, db_user}
    else
      {:create,
       Repo.insert!(%User{
         google_id: google_id,
         email: user["email"],
         name: user["name"],
         google_access_token: google_access_token,
         google_refresh_token: google_refresh_token,
         avatar_url: user["picture"],
         role_id: role_id,
         token_version: 1
       })}
    end
  end
end
