defmodule TaskTrackerWeb.Schemas.UserTypes do
  use Absinthe.Schema.Notation
  alias TaskTrackerWeb.UserResolver

  import_types(TaskTrackerWeb.Types.UserTypes)

  object :user_queries do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:user))) do
      resolve(&UserResolver.all_users/3)
    end
  end

  object :user_mutations do
    @desc "Create a new user"
    field :create_user, :user do
      arg(:email, non_null(:string))

      resolve(&UserResolver.create_user/3)
    end
  end
end
