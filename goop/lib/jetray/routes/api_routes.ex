defmodule Jetray.Routes.ApiRoute do
  import Plug.Conn

  alias Ecto.UUID

  use Plug.Router

  plug(Jetray.Plugs.Cors)
  plug(:match)
  plug(:dispatch)

  get "user/:id" do
    alias Rath.Users
    %Plug.Conn{params: %{"id" => id}} = conn

    case UUID.cast(id) do
      {:ok, uuid} ->
        user = Users.get_by_id_with_role(uuid)

        cond do
          is_nil(user) ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(400, Jason.encode!(%{error: "User does not exist"}))

          true ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              200,
              Jason.encode!(%{user: user})
            )
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{error: "invalid id"})
        )
    end
  end

  get "/roles" do
    alias Rath.Roles

    roles = Roles.get_all_roles()

    cond do
      is_nil(roles) ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Roles does not exist"}))

      true ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{roles: roles}))
    end
  end
end
