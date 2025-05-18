class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    # Summary stats
    @total_users = User.count
    @total_sessions = Meeting.count
    @pending_sessions = Meeting.where(status: "pending").count
    @sessions_by_month = Meeting.group_by_month(:start_time, last: 6).count
    # Recent data for admin overview
    @recent_sessions = Meeting.upcoming.limit(5)
    @all_users = User.all
    @all_meetings = Meeting.all.order(start_time: :desc)
    @all_payments = Payment.all
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
