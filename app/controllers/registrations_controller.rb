class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      resource.role = "client" unless resource.role == "admin" && current_user&.admin?
    end
  end
end