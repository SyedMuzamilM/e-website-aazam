use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    "postgres://postgres:password@localhost/goop_repo"

config :goop, Rath.Repo, url: database_url

config :goop,
  api_url: "https://hidden-beach-94815.herokuapp.com/",
  web_url: "https://afw.surge.sh",
  access_token_secret:
    System.get_env("ACCESS_TOKEN_SECRET") ||
      raise("""
      environment variable ACCESS_TOKEN_SECRET is missing.
      type some random characters to create one
      """),
  refresh_token_secret:
    System.get_env("REFRESH_TOKEN_SECRET") ||
      raise("""
      environment variable REFRESH_TOKEN_SECRET is missing.
      type some random characters to create one
      """),
  client_id:
    System.get_env("GOOGLE_CLIENT_ID") ||
      raise("""
      environment variable GITHUB_CLIENT_ID is missing.
      Create an oauth application on GitHub to get one
      """),
  client_secret:
    System.get_env("GOOGLE_CLIENT_SECRET") ||
      raise("""
      environment variable GITHUB_CLIENT_SECRET is missing.
      Create an oauth application on GitHub to get one
      """)
