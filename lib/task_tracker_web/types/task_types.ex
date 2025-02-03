defmodule TaskTrackerWeb.Types.TaskTypes do
    use Absinthe.Schema.Notation
    import_types Absinthe.Type.Custom
  
    enum :completion_status_type do
        value :completed
        value :not_completed
    end

    object :task do
      field :id, :id
      field :title, :string
      field :description, :string
      field :due_date, :datetime
      field :completion_status, :completion_status_type
    end
end