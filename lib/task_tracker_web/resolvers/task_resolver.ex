defmodule TaskTrackerWeb.TaskResolver do
    alias TaskTracker.Tasks
    alias TaskTracker.Tasks.Task
  
    def all_tasks(_root, _args, _info) do
      {:ok, Tasks.list_tasks()}
    end

    def find_task(_root, args, _info) do
      case Tasks.get_task(args.id) do
        %Task{} = task -> {:ok, task}
        nil -> {:error, "could not find task with id #{args.id}"}
      end
    end

    def create_task(_root, args, _info) do
        # TODO: add detailed error message handling later
        case Tasks.create_task(args) do
          {:ok, link} ->
            {:ok, link}
          error ->
            IO.inspect error
            {:error, "could not create task"}
        end
      end

    def update_task(_root, args, _info) do
        # TODO: catch error for non existent task, and wrong params
        %{id: id} = args

        with  %Task{} = task <- Tasks.get_task(id),
            {:ok, task} <- Tasks.update_task(task, args) do
                {:ok, task}
            else 
                nil -> 
                    {:error, "task with id #{id} does not exist in the system"}
                    
                {:error, error} -> 
                    IO.inspect error
                    {:error, "failed to update"}
        end
    end

    def delete_task(_root, args, _info) do
        %{id: id} = args

        with  %Task{} = task <- Tasks.get_task(id),
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