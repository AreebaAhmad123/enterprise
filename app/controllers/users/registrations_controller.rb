class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      resource.update(consultant_role: true) if resource.persisted? && resource.admin?
    end
  end
end