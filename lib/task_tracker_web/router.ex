defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router
  alias TaskTrackerWeb.Plugs.FetchUserPlug

  pipeline :api do
    plug :accepts, ["json"]
    plug FetchUserPlug
  end

  scope "/api", TaskTrackerWeb do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: TaskTrackerWeb.Schema
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TaskTrackerWeb.Schema,
      interface: :playground,
      context: %{pubsub: TaskTrackerWeb.Endpoint}
  end
end
