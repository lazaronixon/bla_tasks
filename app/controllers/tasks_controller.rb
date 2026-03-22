class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    render json: current_user.tasks
  end

  def show
    render json: @task
  end

  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    head :no_content
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.expect(task: [ :title, :description, :status, :due_date ])
  end
end
