defmodule Goop.Utils.TokenUtils do
  alias Rath.Schemas.User

  def token_to_user(access_token!, refresh_token) do
    access_token! = access_token! || ""

    case Goop.AccessToken.verify_and_validate(access_token!) do
      {:ok, claims} ->
        {:existing_claim, claims["user_id"]}

      _ ->
        verify_refresh_token(refresh_token)
    end
  end

  defp verify_refresh_token(refresh_token!) do
    refresh_token! = refresh_token! || ""

    case Goop.RefreshToken.verify_and_validate(refresh_token!) do
      {:ok, refreshClaims} ->
        user = Rath.Repo.get(User, refreshClaims["user_id"])

        if user &&
             user.token_version == refreshClaims["token_version"] do
          {:new_token, user.id, create_tokens(user), user}
        end

      _ ->
        nil
    end
  end

  def create_tokens(user) do
    %{
      access_token: Goop.AccessToken.generate_and_sign!(%{"user_id" => user.id}),
      refresh_token:
        Goop.RefreshToken.generate_and_sign!(%{
          "user_id" => user.id,
          "token_version" => user.token_version
        })
    }
  end
end
