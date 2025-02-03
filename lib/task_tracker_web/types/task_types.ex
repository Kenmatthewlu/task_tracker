defmodule TaskTrackerWeb.Types.TaskTypes do
    use Absinthe.Schema.Notation
    
    import_types Absinthe.Type.Custom
    import_types TaskTrackerWeb.Types.PaginationTypes
  
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
    
    object :task_pagination do
        field :entries, list_of(:task)
        field :metadata, :pagination_metadata
    end
end