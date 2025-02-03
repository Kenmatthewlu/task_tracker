defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TaskTrackerWeb do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: TaskTrackerWeb.Schema
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TaskTrackerWeb.Schema,
      interface: :simple,
      context: %{pubsub: TaskTrackerWeb.Endpoint}
    end
  end
