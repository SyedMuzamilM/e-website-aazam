defmodule Jetray do
  import Plug.Conn

  use Plug.Router

  plug(Jetray.Plugs.Cors)
  plug(:match)
  plug(:dispatch)

  options _ do
    send_resp(conn, 200, "")
  end

  forward("/hello", to: Jetray.Routes.Home)
  forward("/api/v1", to: Jetray.Routes.ProductsApi)
  forward("/auth/google", to: Jetray.Routes.GoogleAuth)

  get _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "not found")
  end

  post _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "not found")
  end
end
