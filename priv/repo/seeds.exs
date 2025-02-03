# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskTracker.Repo.insert!(%TaskTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaskTracker.Tasks.Task
alias TaskTracker.Accounts.User
alias TaskTracker.Repo

due_date = DateTime.utc_now() |> DateTime.truncate(:second)

%User{email: "dev@test.com"} |> Repo.insert!()

user_id = TaskTracker.Accounts.list_users() |> List.first() |> Map.get(:id)

%Task{
  title: "Task 1",
  description: "Task # 1",
  due_date: due_date,
  completion_status: :completed,
  user_id: user_id
}
|> Repo.insert!()

%Task{
  title: "Task 2",
  description: "Task # 2",
  due_date: due_date,
  completion_status: :not_completed,
  user_id: user_id
}
|> Repo.insert!()
