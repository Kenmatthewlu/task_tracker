defmodule TaskTrackerWeb.Graphql.TaskSchemaTest do
  use TaskTrackerWeb.ConnCase

  @all_tasks_query """
  query allTasks {
    all_tasks {
        id
        title
    }
  }
  """

  describe "all_tasks" do
    setup do
      user = user_fixture()
      task_fixture(%{user_id: user.id})
      task_fixture(%{user_id: user.id})
      task_fixture(%{user_id: user.id})

      {:ok, %{user: user}}
    end

    test "List all tasks", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @all_tasks_query
        })

      assert %{"data" => %{"all_tasks" => tasks}} = json_response(conn, 200)
      assert Enum.count(tasks) == 3
    end
  end

  @search_tasks_query """
  query searchTasks(
    $q: String,
    $ids: [ID], 
    $due_before: DateTime, 
    $completion_status: CompletionStatusType
    ) {
      search_tasks(
        q: $q,
        ids: $ids,
        due_before: $due_before,
        completion_status: $completion_status
      ) {
          id
          title
          description
          due_date
          completion_status
      }
  }
  """

  describe "search_tasks" do
    setup do
      user = user_fixture()
      q_task = task_fixture(%{user_id: user.id, title: "q search"})
      due_task = task_fixture(%{user_id: user.id, due_date: ~U[2025-02-01 00:00:00Z]})
      completed_task = task_fixture(%{user_id: user.id, completion_status: "completed"})
      not_completed_task = task_fixture(%{user_id: user.id, completion_status: "not_completed"})

      assigns = %{
        user: user,
        q_task: q_task,
        due_task: due_task,
        completed_task: completed_task,
        not_completed_task: not_completed_task
      }

      {:ok, assigns}
    end

    test "Search tasks by q", %{conn: conn, q_task: q_task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @search_tasks_query,
          "variables" => %{q: "search"}
        })

      assert %{"data" => %{"search_tasks" => [task | _] = tasks}} = json_response(conn, 200)
      assert Enum.count(tasks) == 1
      assert task["title"] == q_task.title
    end

    test "Search tasks by ids", %{conn: conn, q_task: q_task, due_task: due_task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @search_tasks_query,
          "variables" => %{ids: [q_task.id, due_task.id]}
        })

      assert %{"data" => %{"search_tasks" => tasks}} = json_response(conn, 200)
      assert Enum.count(tasks) == 2
      assert Enum.find(tasks, &(&1["id"] == Integer.to_string(q_task.id)))
      assert Enum.find(tasks, &(&1["id"] == Integer.to_string(due_task.id)))
    end

    test "Search tasks by due_before", %{conn: conn, due_task: due_task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @search_tasks_query,
          "variables" => %{due_before: "2025-02-02 00:00:00Z"}
        })

      assert %{"data" => %{"search_tasks" => [task | _] = tasks}} = json_response(conn, 200)
      assert Enum.count(tasks) == 1
      assert task["id"] == Integer.to_string(due_task.id)
    end

    test "Search tasks by completion_status", %{conn: conn, completed_task: completed_task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @search_tasks_query,
          "variables" => %{completion_status: "COMPLETED"}
        })

      assert %{"data" => %{"search_tasks" => [task | _] = tasks}} = json_response(conn, 200)
      assert Enum.count(tasks) == 1
      assert task["id"] == Integer.to_string(completed_task.id)
    end
  end

  @get_task_query """
  query getTask($id: ID!) {
      get_task(id: $id) {
          id
          title
      }
  }
  """

  describe "get_task" do
    setup do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})

      {:ok, %{user: user, task: task}}
    end

    test "Get existing task", %{conn: conn, user: user, task: task} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @get_task_query,
          "variables" => %{id: task.id}
        })

      assert json_response(conn, 200)
    end

    test "Get non-existent task", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @get_task_query,
          "variables" => %{id: -1}
        })

      assert %{
               "errors" => [
                 %{"message" => "could not find task with id -1"}
               ]
             } = json_response(conn, 200)
    end
  end

  @create_task_query """
  mutation createTask(
    $title: String!,
    $due_date: DateTime!,
    $description: String,
    $completion_status: CompletionStatusType!
  ) {
    create_task(
        title: $title,
        due_date: $due_date,
        description: $description,
        completion_status: $completion_status
    ) {
        id
        title
        due_date
        description
        user_id
        completion_status
    }
  }
  """

  @valid_create_attrs %{
    title: "valid_title",
    description: "valid_description",
    due_date: "2025-02-03T16:48:48Z",
    completion_status: "COMPLETED"
  }

  @invalid_create_attrs %{
    title: nil
  }

  describe "create_task" do
    setup do
      user = user_fixture()

      {:ok, %{user: user}}
    end

    test "create a task with valid data", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @create_task_query,
          "variables" => @valid_create_attrs
        })

      assert %{"data" => %{"create_task" => task}} = json_response(conn, 200)
      assert task["title"] == @valid_create_attrs.title
      assert task["description"] == @valid_create_attrs.description
      assert task["completion_status"] == @valid_create_attrs.completion_status
      assert task["due_date"] == @valid_create_attrs.due_date
    end

    test "create a task with invalid data", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @create_task_query,
          "variables" => @invalid_create_attrs
        })

      assert %{"errors" => errors} = json_response(conn, 200)

      assert Enum.find(
               errors,
               &(&1["message"] == "Variable \"title\": Expected non-null, found null.")
             )

      assert Enum.find(errors, &(&1["message"] == "Argument \"title\" has invalid value $title."))
    end

    test "create a task with no logged in user", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{
          "query" => @create_task_query,
          "variables" => @valid_create_attrs
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "unauthorized"
    end
  end

  @update_task_query """
  mutation updateTask(
    $id: ID!,
    $title: String!,
    $due_date: DateTime,
    $description: String,
    $completion_status: CompletionStatusType
  ) {
    update_task(
        id: $id,
        title: $title,
        due_date: $due_date,
        description: $description,
        completion_status: $completion_status
    ) {
        id
        title
        due_date
        description
        user_id
        completion_status
    }
  }
  """

  @valid_update_attrs %{
    title: "valid_title",
    description: "valid_description",
    due_date: "2025-02-03T16:48:48Z",
    completion_status: "COMPLETED"
  }

  @invalid_update_attrs %{
    title: nil
  }

  describe "update_task" do
    setup do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})

      {:ok, %{user: user, task: task}}
    end

    test "update a task with valid data", %{conn: conn, user: user, task: task} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @update_task_query,
          "variables" => @valid_update_attrs |> Map.put("id", task.id)
        })

      assert %{"data" => %{"update_task" => task}} = json_response(conn, 200)
      assert task["title"] == @valid_update_attrs.title
      assert task["description"] == @valid_update_attrs.description
      assert task["due_date"] == @valid_update_attrs.due_date
      assert task["completion_status"] == @valid_update_attrs.completion_status
    end

    test "update a task with invalid data", %{conn: conn, user: user, task: task} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @update_task_query,
          "variables" => @invalid_update_attrs |> Map.put("id", task.id)
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "Variable \"title\": Expected non-null, found null."
    end

    test "update a task with valid data but with a different user", %{conn: conn, task: task} do
      diff_user = user_fixture()

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{diff_user.id}")
        |> post("/api", %{
          "query" => @update_task_query,
          "variables" => @valid_update_attrs |> Map.put("id", task.id)
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "unauthorized"
    end

    test "update a task with valid data but with no logged in user", %{conn: conn, task: task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @update_task_query,
          "variables" => @valid_update_attrs |> Map.put("id", task.id)
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "unauthorized"
    end
  end

  @delete_task_query """
  mutation deleteTask($id: ID!) {
    delete_task(id: $id) {
        id
        title
        due_date
        description
        user_id
        completion_status
    }
  }
  """
  describe "delete_task" do
    setup do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})

      {:ok, %{user: user, task: task}}
    end

    test "delete an existing task", %{conn: conn, user: user, task: task} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @delete_task_query,
          "variables" => %{id: task.id}
        })

      assert %{"data" => %{"delete_task" => deleted_task}} = json_response(conn, 200)
      assert deleted_task["id"] == Integer.to_string(task.id)
    end

    test "delete a non-existing task", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{user.id}")
        |> post("/api", %{
          "query" => @delete_task_query,
          "variables" => %{id: -1}
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "not_found"
    end

    test "delete an existing task with a different user", %{conn: conn, task: task} do
      diff_user = user_fixture()

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{diff_user.id}")
        |> post("/api", %{
          "query" => @delete_task_query,
          "variables" => %{id: task.id}
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "unauthorized"
    end

    test "delete an existing task with no logged in user", %{conn: conn, task: task} do
      conn =
        conn
        |> post("/api", %{
          "query" => @delete_task_query,
          "variables" => %{id: task.id}
        })

      assert %{"errors" => [error | _]} = json_response(conn, 200)
      assert error["message"] == "unauthorized"
    end
  end
end
