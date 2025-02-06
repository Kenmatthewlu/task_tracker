defmodule TaskTrackerWeb.Resolvers.UserResolver do
  alias TaskTracker.Accounts

  def all_users(_root, _args, _info) do
    {:ok, Accounts.list_users()}
  end

  def create_user(_root, args, _info) do
    case Accounts.create_user(args) do
      {:ok, link} ->
        {:ok, link}

      _error ->
        {:error, "could not create user"}
    end
  end
end
