defmodule TaskTracker.Repo do
  use Ecto.Repo,
    otp_app: :task_tracker,
    adapter: Ecto.Adapters.MyXQL

  use Paginator
end
