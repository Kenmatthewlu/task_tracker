defmodule TaskTrackerWeb.Schemas.UserTokenTypes do
  use Absinthe.Schema.Notation
  alias TaskTrackerWeb.Resolvers.UserTokenResolver
  alias TaskTrackerWeb.Middleware.{Authenticated, Unauthenticated}

  import_types(TaskTrackerWeb.Types.UserTokenTypes)

  object :user_token_mutations do
    @desc "Creates a new user token session"
    field :login, :user_token do
      middleware(Unauthenticated)
      arg(:email, non_null(:string))

      resolve(&UserTokenResolver.login/3)
    end

    @desc "Logs out the current user"
    field :logout, :logout_user_token do
      middleware(Authenticated)

      resolve(&UserTokenResolver.logout/3)
    end
  end
end
