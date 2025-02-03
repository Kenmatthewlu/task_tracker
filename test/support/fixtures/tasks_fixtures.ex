defmodule TaskTracker.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskTracker.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completion_status: "some completion_status",
        description: "some description",
        due_date: ~U[2025-02-02 02:46:00Z],
        title: "some title"
      })
      |> TaskTracker.Tasks.create_task()

    task
  end
end
