defmodule Jetray.Routes.ApiRoute do
  import Plug.Conn

  alias Ecto.UUID

  use Plug.Router

  plug(Jetray.Plugs.Cors)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

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

  post "/post-some-data" do
    response = conn.body_params
    response |> handle_response(conn)
  end

  defp handle_response(response, conn) do
    IO.inspect(response)

    # %{code: code, message: message} =
    #   case response do
    #     {:ok, message} -> %{code: 200, message: message}
    #     {:not_fount, message} -> %{code: 404, message: message}
    #     {:malformed_data, message} -> %{code: 400, message: message}
    #     {:server_error, message} -> %{code: 500, message: message}
    #   end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "Got the data"}))
  end

  post "/some-more-data-to-post" do
    # IO.inspect(conn.body_params)
    data = conn.body_params

    send_resp(conn, 200, "Success! #{data["name"]}")
  end
end
