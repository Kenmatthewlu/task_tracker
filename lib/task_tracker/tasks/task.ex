defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completion_status, Ecto.Enum,
      values: [completed: "completed", not_completed: "not_completed"],
      default: :not_completed

    field :description, :string
    field :title, :string
    field :due_date, :utc_datetime
    belongs_to(:user, TaskTracker.Accounts.User)

    timestamps(type: :utc_datetime)
  end

  @required_fields [:title, :user_id]
  @optional_fields [:description, :due_date, :completion_status]

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
