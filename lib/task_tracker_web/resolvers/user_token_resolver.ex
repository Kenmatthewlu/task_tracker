defmodule TaskTrackerWeb.Resolvers.UserTokenResolver do
  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User
  alias TaskTracker.Accounts.UserToken

  def login(_root, %{email: email}, _info) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         %UserToken{} = user_token <- Accounts.generate_user_session_token(user) do
      {:ok, user_token}
    else
      _ ->
        {:error, :invalid_credentials}
    end
  end

  def logout(_root, _args, %{context: %{token: token}}) do
    :ok = Accounts.delete_user_session_token(token)

    {:ok, %{successful: true}}
  end
end
