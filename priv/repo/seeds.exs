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
alias TaskTracker.Repo

due_date = DateTime.utc_now() |> DateTime.truncate(:second)

%Task{id: 1, title: "Task 1", description: "Task # 1", due_date: due_date, completion_status: "completed"} |> Repo.insert! 
%Task{id: 2, title: "Task 2", description: "Task # 2", due_date: due_date, completion_status: "not_completed"} |> Repo.insert!