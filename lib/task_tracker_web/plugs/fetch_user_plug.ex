defmodule TaskTrackerWeb.Plugs.FetchUserPlug do
  @behaviour Plug

  import Plug.Conn
  alias TaskTracker.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> user_id] <- get_req_header(conn, "authorization"),
         %Accounts.User{} = user <- Accounts.get_user!(user_id) do
      Absinthe.Plug.assign_context(conn, :current_user, user)
    else
      _ ->
        conn
    end
  end
end
