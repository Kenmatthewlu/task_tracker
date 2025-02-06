defmodule TaskTrackerWeb.Graphql.UserSchemaTest do
  use TaskTrackerWeb.ConnCase

  @all_users_query """
  query allUsers {
    all_users {
        id
    }
  }
  """

  describe "all_users" do
    test "List all users", %{conn: conn} do
      for number <- 1..3 do
        user_fixture(%{email: "dev#{number}@test.com"})
      end

      conn =
        conn
        |> post("/api", %{
          "query" => @all_users_query
        })

      assert %{"data" => %{"all_users" => users}} = json_response(conn, 200)
      assert Enum.count(users) == 3
    end
  end

  @create_user_query """
  mutation createUser(
    $email: String!
  ) {
    create_user(
      email: $email
    ) {
        id
        email
    }
  }
  """

  describe "create_user" do
    test "create a user with valid data", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{
          "query" => @create_user_query,
          "variables" => %{email: "new_user@email.com"}
        })

      assert %{"data" => %{"create_user" => user}} = json_response(conn, 200)
      assert user["email"] == "new_user@email.com"
    end
  end
end
