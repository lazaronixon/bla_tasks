require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:one)
    @headers = { "X-User-Id" => @user.id }
  end

  test "should return unauthorized without user header" do
    get tasks_url, as: :json
    assert_response :unauthorized
  end

  test "should get index" do
    get tasks_url, headers: @headers, as: :json
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: { task: { title: "New task", description: "Details", due_date: "2026-05-01" } }, headers: @headers, as: :json
    end

    assert_response :created
  end

  test "should show task" do
    get task_url(@task), headers: @headers, as: :json
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: { status: "in_progress" } }, headers: @headers, as: :json
    assert_response :success
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task), headers: @headers, as: :json
    end

    assert_response :no_content
  end

  test "should not show another user's task" do
    get task_url(@task), headers: { "X-User-Id" => users(:two).id }, as: :json
    assert_response :not_found
  end
end
