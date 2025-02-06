defmodule TaskTrackerWeb.Types.UserTokenTypes do
  use Absinthe.Schema.Notation

  object :user_token do
    field :token, non_null(:string)
    field :user_id, :id
  end

  object :logout_user_token do
    field :successful, :boolean
  end
end
