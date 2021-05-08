defmodule WayBig.Google do
  def get_user(accessToken) do
    case(
      HTTPoison.get(
        "https://www.googleapis.com/oauth2/v2/userinfo",
        [
          {"Authorization", "Bearer" <> accessToken}
        ]
      )
    ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data = Jason.decode!(body)
        data

      x ->
        IO.inspect(x)
        nil
    end
  end
end
