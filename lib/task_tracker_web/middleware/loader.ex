defmodule TaskTrackerWeb.Middleware.Loader do
  @behaviour Absinthe.Middleware

  def call(%{state: :resolved} = resolution, _config), do: resolution

  def call(%{arguments: arguments, context: context} = resolution, config) do
    loader = config[:loader] || raise ArgumentError, ":loader is required"
    id_path = config[:id_path] || [:id]
    resource_key = config[:resource_key] || :resource

    id = get_in(arguments, id_path)

    loader_result =
      try do
        loader.(id)
      rescue
        e in Ecto.NoResultsError -> e
      end

    case loader_result do
      nil ->
        Absinthe.Resolution.put_result(resolution, {:error, :not_found})

      %Ecto.NoResultsError{} ->
        Absinthe.Resolution.put_result(resolution, {:error, :not_found})

      resource ->
        %{
          resolution
          | context: Map.put(context, resource_key, resource)
        }
    end
  end

  def call(resolution, _config), do: resolution
end
