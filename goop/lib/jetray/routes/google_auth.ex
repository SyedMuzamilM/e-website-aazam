defmodule Jetray.Routes.GoogleAuth do
  require Logger

  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/web" do
    url =
      "https://accounts.google.com/o/oauth2/v2/auth?client_id=" <>
        Application.get_env(:goop, :client_id) <>
        "&state=web" <>
        "&access_type=offline" <>
        "&response_type=code" <>
        "&scope=https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile" <>
        "&redirect_uri=" <>
        Application.get_env(:goop, :api_url) <>
        "/auth/google/callback"

    Jetray.Plugs.Redirect.redirect(conn, url)
  end

  get "/callback" do
    conn_with_qp = fetch_query_params(conn)
    code = conn_with_qp.query_params["code"]

    case HTTPoison.post(
           "https://oauth2.googleapis.com/token",
           Jason.encode!(%{
             "code" => code,
             "client_id" => Application.get_env(:goop, :client_id),
             "client_secret" => Application.get_env(:goop, :client_secret),
             "redirect_uri" => Application.get_env(:goop, :api_url) <> "/auth/google/callback",
             "grant_type" => "authorization_code"
           }),
           [
             {"Content-Type", "application/json"},
             {"Accept", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Jason.decode!(body)
        IO.inspect(json)

        case json do
          %{"error" => "bad_verification_code"} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              500,
              Jason.encode!(%{
                "error" => "code expired, try to login again"
              })
            )

          %{"access_token" => accessToken, "refresh_token" => refreshToken} ->
            alias Rath.Roles
            user = WayBig.Google.get_user(accessToken)

            if user do
              try do
                db_user =
                  case Rath.Mutations.Users.google_find_or_create(
                         user,
                         accessToken,
                         refreshToken
                       ) do
                    {:find, uu} ->
                      uu

                    {:create, uu} ->
                      uu
                  end

                user_role = Roles.get_role_by_id(db_user.role_id).name
                base_url = Application.get_env(:goop, :web_url)

                conn
                |> put_resp_content_type("application/json")
                |> Jetray.Plugs.Redirect.redirect(
                  base_url <>
                    "/?access_token=" <>
                    Goop.AccessToken.generate_and_sign!(%{"user_id" => db_user.id}) <>
                    "&refresh_token=" <>
                    Goop.RefreshToken.generate_and_sign!(%{
                      "user_id" => db_user.id,
                      "token_version" => db_user.token_version
                    }) <>
                    "&role=" <> user_role
                )
              rescue
                e in RuntimeError ->
                  conn
                  |> put_resp_content_type("application/json")
                  |> send_resp(500, Jason.encode!(%{"error" => e.message}))
              end
            else
              conn
              |> put_resp_content_type("application/json")
              |> send_resp(
                500,
                Jason.encode!(%{
                  "error" =>
                    "something went wrong fetching the user, tell ben to check the server logs"
                })
              )
            end

          resp ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              500,
              Jason.encode!(%{resp: resp})
            )
        end

      x ->
        IO.inspect(x)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          500,
          Jason.encode!(%{"error" => "something went wrong, tell ben to check the server logs"})
        )
    end
  end
end
