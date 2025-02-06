defmodule TaskTracker.AccountsFixtures do
  alias TaskTracker.Accounts

  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskTracker.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email"
      })
      |> Accounts.create_user()

    user
  end

  def generate_user_token(user_id) do
    user_id
    |> Accounts.get_user!()
    |> Accounts.generate_user_session_token()
  end
end
