class Users::SessionsController < Devise::SessionsController
  def new_admin
    self.resource = resource_class.new(sign_in_params)
    render :new_admin
  end

  def create_admin
    self.resource = warden.authenticate!(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      resource.update(acting_as_admin: true)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = 'Invalid email or password'
      self.resource = resource_class.new(sign_in_params)
      render :new_admin, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.acting_as_admin?
      current_user.update(acting_as_admin: false)
    end
    super
  end

  private

  def auth_options
    if action_name == 'create_admin'
      { scope: :user, recall: "#{controller_path}#new_admin" }
    else
      { scope: :user }
    end
  end

  def after_sign_in_path_for(resource)
    if resource.acting_as_admin?
      admin_dashboard_path
    else
      dashboard_path
    end
  end
end 