defmodule TaskTrackerWeb.Middleware.Unauthenticated do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: %{id: _}}} = info, _config) do
    Absinthe.Resolution.put_result(info, {:error, :forbidden})
  end

  def call(info, _config) do
    info
  end
end
