defmodule TaskTrackerWeb.Schemas.TaskTypes do
  use Absinthe.Schema.Notation
  alias TaskTracker.Tasks
  alias TaskTrackerWeb.TaskResolver
  alias TaskTrackerWeb.Middleware.{Authenticated, Loader, AuthorizeResource}

  import_types(TaskTrackerWeb.Types.TaskTypes)

  object :task_queries do
    @desc "Get all tasks"
    field :all_tasks, non_null(list_of(non_null(:task))) do
      resolve(&TaskResolver.all_tasks/3)
    end

    @desc "Paginate tasks"
    field :paginate_tasks, :task_pagination do
      arg(:pagination, non_null(:pagination_input))

      resolve(&TaskResolver.paginate_tasks/3)
    end

    @desc "Filter tasks"
    field :search_tasks, non_null(list_of(non_null(:task))) do
      arg(:q, :string)
      arg(:ids, list_of(:id))
      arg(:due_before, :datetime)
      arg(:completion_status, :completion_status_type)

      resolve(&TaskResolver.search_tasks/3)
    end

    @desc "Get a task by id"
    field :get_task, non_null(:task) do
      arg(:id, non_null(:id))

      resolve(&TaskResolver.find_task/3)
    end
  end

  object :task_mutations do
    @desc "Create a new task"
    field :create_task, :task do
      middleware(Authenticated)

      arg(:title, non_null(:string))
      arg(:description, :string)
      arg(:due_date, :datetime)
      arg(:completion_status, :completion_status_type)

      resolve(&TaskResolver.create_task/3)
    end

    @desc "Updates an existing task"
    field :update_task, :task do
      middleware(Authenticated)

      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:description, :string)
      arg(:due_date, :datetime)
      arg(:completion_status, :completion_status_type)

      middleware(Loader, loader: &Tasks.get_task!/1)
      middleware(AuthorizeResource)

      resolve(&TaskResolver.update_task/3)
    end

    @desc "Deletes an existing task"
    field :delete_task, :task do
      middleware(Authenticated)

      arg(:id, non_null(:id))

      middleware(Loader, loader: &Tasks.get_task!/1)
      middleware(AuthorizeResource)

      resolve(&TaskResolver.delete_task/3)
    end
  end
end
