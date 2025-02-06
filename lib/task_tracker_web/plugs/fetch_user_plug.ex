defmodule TaskTrackerWeb.Plugs.FetchUserPlug do
  @behaviour Plug

  import Plug.Conn
  alias TaskTracker.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         %Accounts.User{} = user <- Accounts.get_user_by_session_token(token) do
      Absinthe.Plug.assign_context(conn, %{current_user: user, token: token})
    else
      _ ->
        conn
    end
  end
end
