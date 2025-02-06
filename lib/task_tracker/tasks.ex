defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Returns paginated tasks.
  """

  def paginate_tasks(pagination \\ %{}) do
    repo_pagination =
      pagination
      |> Enum.into(Keyword.new())
      |> Keyword.put_new(:limit, 20)
      |> Keyword.put(:cursor_fields, [:inserted_at, :id])

    Repo.paginate(Task, repo_pagination)
  end

  @doc """
  Returns a list of filtered tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def search_tasks(params \\ %{}) do
    Task
    |> query_by(params)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  ## Examples

      iex> get_task(123)
      {:ok, %Task{}}

      iex> get_task(456)
      {:error, "could not find task with id 456"}

  """
  def get_task(id), do: Repo.get(Task, id)

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  defp query_by(query, %{q: search_query} = params) do
    query =
      from q in query,
        where: ilike(q.title, ^"%#{search_query}%") or ilike(q.description, ^"%#{search_query}%")

    query_by(query, Map.delete(params, :q))
  end

  defp query_by(query, %{ids: ids} = params) do
    query =
      from q in query,
        where: q.id in ^ids

    query_by(query, Map.delete(params, :ids))
  end

  defp query_by(query, %{due_before: datetime} = params) do
    query =
      from q in query,
        where: q.due_date < ^datetime

    query_by(query, Map.delete(params, :due_before))
  end

  defp query_by(query, %{completion_status: completion_status} = params) do
    query =
      from q in query,
        where: q.completion_status == ^completion_status

    query_by(query, Map.delete(params, :completion_status))
  end

  defp query_by(query, _params), do: query
end
