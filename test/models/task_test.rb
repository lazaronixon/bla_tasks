require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "valid task" do
    task = Task.new(user: users(:one), title: "Test", description: "Desc")
    assert task.valid?
  end

  test "invalid without title" do
    task = Task.new(user: users(:one), description: "Desc")
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "invalid without description" do
    task = Task.new(user: users(:one), title: "Test")
    assert_not task.valid?
    assert_includes task.errors[:description], "can't be blank"
  end

  test "invalid without user" do
    task = Task.new(title: "Test", description: "Desc")
    assert_not task.valid?
    assert_includes task.errors[:user], "must exist"
  end

  test "invalid with bad status" do
    task = Task.new(user: users(:one), title: "Test", description: "Desc", status: "invalid")
    assert_not task.valid?
    assert_includes task.errors[:status], "is not included in the list"
  end

  test "status defaults to todo" do
    task = Task.new(user: users(:one), title: "Test", description: "Desc")
    assert_equal "todo", task.status
  end

  test "allows all valid statuses" do
    %w[todo in_progress done].each do |status|
      task = Task.new(user: users(:one), title: "Test", description: "Desc", status: status)
      assert task.valid?, "Expected #{status} to be valid"
    end
  end

  test "due_date is optional" do
    task = Task.new(user: users(:one), title: "Test", description: "Desc", due_date: nil)
    assert task.valid?
  end

  test "past due_date is allowed" do
    task = Task.new(user: users(:one), title: "Test", description: "Desc", due_date: Date.yesterday)
    assert task.valid?
  end

  test "destroying user destroys tasks" do
    user = users(:one)
    assert_difference("Task.count", -user.tasks.count) do
      user.destroy
    end
  end
end
