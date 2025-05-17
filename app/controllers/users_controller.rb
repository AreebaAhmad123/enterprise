class UsersController < ApplicationController
  before_action :require_login

  def profile
    @user = current_user || User.new # Fallback for demo purposes
  end
end