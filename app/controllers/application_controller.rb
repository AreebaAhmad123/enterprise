class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActionController::UnknownFormat, with: :render_404
  rescue_from ActionController::UnknownHttpMethod, with: :render_404

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :consultant_role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :consultant_role])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('app', 'views', 'errors', 'not_found.html.erb'), status: :not_found, layout: false }
      format.json { render json: { error: 'Not Found' }, status: :not_found }
      format.any { head :not_found }
    end
  end
end