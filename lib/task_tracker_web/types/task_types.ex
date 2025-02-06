defmodule TaskTrackerWeb.Types.TaskTypes do
  use Absinthe.Schema.Notation

  enum :completion_status_type do
    value(:completed)
    value(:not_completed)
  end

  object :task do
    field :id, :id
    field :title, :string
    field :user_id, :id
    field :description, :string
    field :due_date, :datetime
    field :completion_status, :completion_status_type
  end

  object :task_pagination do
    field :entries, list_of(:task)
    field :metadata, :pagination_metadata
  end
end
