require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:one)
    @headers = { "X-User-Id" => @user.id.to_s }
  end

  # --- Authentication ---

  test "returns 401 without X-User-Id header" do
    get tasks_url
    assert_response :unauthorized
  end

  test "returns 401 with invalid X-User-Id" do
    get tasks_url, headers: { "X-User-Id" => "999999" }
    assert_response :unauthorized
  end

  test "returns 401 with non-numeric X-User-Id" do
    get tasks_url, headers: { "X-User-Id" => "abc" }
    assert_response :unauthorized
  end

  # --- INDEX ---

  test "index returns only current user tasks" do
    get tasks_url, headers: @headers
    assert_response :success

    tasks = response.parsed_body
    assert_equal @user.tasks.count, tasks.size
    tasks.each do |task|
      assert_equal @user.id, task["user_id"]
    end
  end

  # --- SHOW ---

  test "show returns a task" do
    get task_url(@task), headers: @headers
    assert_response :success

    body = response.parsed_body
    assert_equal @task.id, body["id"]
    assert_equal @task.title, body["title"]
  end

  test "show returns 404 for nonexistent task" do
    get task_url(id: 999999), headers: @headers
    assert_response :not_found
  end

  test "show returns 404 for other user task" do
    other_task = tasks(:other_user_task)
    get task_url(other_task), headers: @headers
    assert_response :not_found
  end

  # --- CREATE ---

  test "create with valid params" do
    assert_difference("Task.count", 1) do
      post tasks_url,
        params: { task: { title: "New task", description: "Details", due_date: "2026-04-15" } },
        headers: @headers
    end

    assert_response :created

    body = response.parsed_body
    assert_equal "New task", body["title"]
    assert_equal "todo", body["status"]
    assert_equal @user.id, body["user_id"]
  end

  test "create with explicit status" do
    post tasks_url,
      params: { task: { title: "Urgent", description: "Now", status: "in_progress" } },
      headers: @headers

    assert_response :created
    assert_equal "in_progress", response.parsed_body["status"]
  end

  test "create with missing title returns 422" do
    post tasks_url,
      params: { task: { description: "No title" } },
      headers: @headers

    assert_response :unprocessable_entity
  end

  test "create with missing description returns 422" do
    post tasks_url,
      params: { task: { title: "No desc" } },
      headers: @headers

    assert_response :unprocessable_entity
  end

  test "create with invalid status returns 422" do
    post tasks_url,
      params: { task: { title: "Bad", description: "Status", status: "invalid" } },
      headers: @headers

    assert_response :unprocessable_entity
  end

  # --- UPDATE ---

  test "update with valid params" do
    patch task_url(@task),
      params: { task: { title: "Updated title", status: "done" } },
      headers: @headers

    assert_response :success
    assert_equal "Updated title", response.parsed_body["title"]
    assert_equal "done", response.parsed_body["status"]
  end

  test "update with invalid status returns 422" do
    patch task_url(@task),
      params: { task: { status: "invalid" } },
      headers: @headers

    assert_response :unprocessable_entity
  end

  test "update other user task returns 404" do
    other_task = tasks(:other_user_task)
    patch task_url(other_task),
      params: { task: { title: "Hacked" } },
      headers: @headers

    assert_response :not_found
  end

  # --- DESTROY ---

  test "destroy deletes the task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task), headers: @headers
    end

    assert_response :no_content
  end

  test "destroy other user task returns 404" do
    other_task = tasks(:other_user_task)

    assert_no_difference("Task.count") do
      delete task_url(other_task), headers: @headers
    end

    assert_response :not_found
  end

  test "destroy nonexistent task returns 404" do
    delete task_url(id: 999999), headers: @headers
    assert_response :not_found
  end
end
