class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Set email, consultant_role, and role based on the form parameters
        is_consultant = params[:user][:consultant_role] == 'true'
        resource.update(
          email: params[:user][:email],
          consultant_role: is_consultant,
          role: is_consultant ? 'consultant' : 'client'
        )
      end
    end
  end
end