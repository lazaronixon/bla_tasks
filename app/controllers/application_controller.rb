class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    @current_user = User.find_by(id: request.headers["X-User-Id"])
    head :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
