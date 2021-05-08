defmodule Goop do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Goop.Worker.start_link(arg)
      # {Goop.Worker, arg}
      {Rath.Repo, []},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Jetray,
        options: [
          port: String.to_integer(System.get_env("PORT") || "4000"),
          dispatch: dispatch(),
          protocol_options: [idle_timeout: :infinity]
        ]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Goop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch() do
    [
      {:_,
       [
         {"/socket", Jetray.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Jetray, []}}
       ]}
    ]
  end
end
