class RegistrationsController < Devise::RegistrationsController
  before_action :ensure_client_cannot_change_role, only: :update

  def create
    super do |resource|
      # Set default role to "client" unless created by an admin
      resource.role = "client" unless resource.role == "admin" && current_user&.admin?
    end
  end

  private

  def ensure_client_cannot_change_role
    if current_user&.client? && params[:user][:role].present?
      flash[:alert] = "You cannot change your role."
      redirect_to edit_user_registration_path
    end
  end
end
