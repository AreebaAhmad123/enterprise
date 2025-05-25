class RegistrationsController < Devise::RegistrationsController
  before_action :ensure_client_cannot_change_role, only: :update

  def create
    super do |resource|
      if resource.persisted?
        resource.update(consultant_role: params[:user][:consultant_role] == "true")
      end
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
