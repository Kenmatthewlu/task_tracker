defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :due_date, :utc_datetime
      add :completion_status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
