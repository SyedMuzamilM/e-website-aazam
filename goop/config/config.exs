use Mix.Config

config(:goop, ecto_repos: [Rath.Repo])

import_config "#{Mix.env()}.exs"
