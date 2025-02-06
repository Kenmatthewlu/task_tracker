defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router
  alias TaskTrackerWeb.Plugs.FetchUserPlug

  pipeline :api do
    plug :accepts, ["json"]
    plug FetchUserPlug
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug,
      schema: TaskTrackerWeb.Schema,
      socket: TaskTrackerWeb.UserSocket,
      socket_url: "ws://localhost:4000/api/graphql"
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TaskTrackerWeb.Schema,
      interface: :playground,
      context: %{pubsub: TaskTrackerWeb.Endpoint},
      socket: TaskTrackerWeb.UserSocket,
      socket_url: "ws://localhost:4000/api/graphql"
  end
end
