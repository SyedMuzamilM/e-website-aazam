defmodule Rath.Repo do
  use Ecto.Repo,
    otp_app: :goop,
    adapter: Ecto.Adapters.Postgres
end
