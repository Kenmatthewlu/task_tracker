defmodule TaskTrackerWeb.Resolvers.TaskResolver do
  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task
  alias TaskTracker.Accounts.User

  def all_tasks(_root, _args, _info) do
    {:ok, Tasks.list_tasks()}
  end

  def paginate_tasks(_root, args, _info) do
    pagination = Map.get(args, :pagination, %{})
    {:ok, Tasks.paginate_tasks(pagination)}
  end

  def search_tasks(_root, args, _info) do
    {:ok, Tasks.search_tasks(args)}
  end

  def find_task(_root, args, _info) do
    case Tasks.get_task(args.id) do
      %Task{} = task -> {:ok, task}
      nil -> {:error, "could not find task with id #{args.id}"}
    end
  end

  def create_task(_root, args, %{context: %{current_user: %User{} = user}}) do
    args = Map.put(args, :user_id, user.id)

    case Tasks.create_task(args) do
      {:ok, link} ->
        {:ok, link}

      _error ->
        {:error, "could not create task"}
    end
  end

  def create_task(_root, _args, _info) do
    {:error, :unauthorized}
  end

  def update_task(_root, args, _info) do
    %{id: id} = args

    with %Task{} = task <- Tasks.get_task(id),
         {:ok, task} <- Tasks.update_task(task, args) do
      {:ok, task}
    else
      nil ->
        {:error, "task with id #{id} does not exist in the system"}

      {:error, _error} ->
        {:error, "failed to update"}
    end
  end

  def delete_task(_root, args, _info) do
    %{id: id} = args

    with %Task{} = task <- Tasks.get_task(id),
         {:ok, task} <- Tasks.delete_task(task) do
      {:ok, task}
    else
      nil ->
        {:error, "task with id #{id} does not exist in the system"}

      _error ->
        {:error, "failed to delete"}
    end
  end
end
