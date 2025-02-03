defmodule TaskTrackerWeb.Schema do
    use Absinthe.Schema
  
    alias TaskTrackerWeb.TaskResolver

    import_types TaskTrackerWeb.Types.TaskTypes
  
    query do
        @desc "Paginate tasks"
        field :paginate_tasks, :task_pagination do
          arg :pagination, non_null(:pagination_input)

          resolve(&TaskResolver.paginate_tasks/3)
        end

      @desc "Get all tasks"
      field :all_tasks, non_null(list_of(non_null(:task))) do
        resolve(&TaskResolver.all_tasks/3)
      end

      @desc "View a task by id"
      field :view_task, non_null(:task) do
        arg :id, non_null(:id)
        resolve(&TaskResolver.find_task/3)
      end
    end

    mutation do
      @desc "Create a new task"
      field :create_task, :task do
        arg :title, non_null(:string)
        arg :description, :string
        arg :due_date, :datetime
        arg :completion_status, :completion_status_type
      
        resolve &TaskResolver.create_task/3
      end

      @desc "Updates an existing task"
      field :update_task, :task do
        arg :id, non_null(:id)
        arg :title, :string
        arg :description, :string
        arg :due_date, :datetime
        arg :completion_status, :completion_status_type
      
        resolve &TaskResolver.update_task/3
      end

      @desc "Deletes an existing task"
      field :delete_task, :task do
        arg :id, non_null(:id)

        resolve &TaskResolver.delete_task/3
      end
    end
  end