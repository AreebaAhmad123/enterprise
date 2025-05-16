class Admin::MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @meetings = Meeting.all.order(start_time: :desc)
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.update(status: 'canceled')
    redirect_to admin_dashboard_path, notice: 'Meeting canceled.'
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.role == 'admin'
  end
end