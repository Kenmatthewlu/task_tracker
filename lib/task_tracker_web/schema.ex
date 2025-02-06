defmodule TaskTrackerWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(TaskTrackerWeb.Types.PaginationTypes)
  import_types(Absinthe.Type.Custom)
  import_types(TaskTrackerWeb.Schemas.TaskTypes)
  import_types(TaskTrackerWeb.Schemas.UserTypes)
  import_types(TaskTrackerWeb.Schemas.UserTokenTypes)

  query do
    import_fields(:task_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:task_mutations)
    import_fields(:user_mutations)
    import_fields(:user_token_mutations)
  end
end
