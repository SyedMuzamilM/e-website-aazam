defmodule Jetray.Routes.Home do
  import Plug.Conn

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> send_resp(200, "world")
  end
end
