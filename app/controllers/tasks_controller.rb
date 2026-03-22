class TasksController < ApplicationController
  before_action :set_task, only: %i[ show update destroy ]

  def index
    @tasks = current_user.tasks

    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!
  end

  private
    def set_task
      @task = current_user.tasks.find(params.expect(:id))
    end

    def task_params
      params.expect(task: [ :title, :description, :status, :due_date ])
    end
end
