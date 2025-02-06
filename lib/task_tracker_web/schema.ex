defmodule TaskTrackerWeb.Schema do
  use Absinthe.Schema

  import_types(TaskTrackerWeb.Schemas.TaskTypes)
  import_types(TaskTrackerWeb.Schemas.UserTypes)

  query do
    import_fields(:task_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:task_mutations)
    import_fields(:user_mutations)
  end
end
