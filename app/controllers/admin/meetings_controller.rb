class Admin::MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_meeting, only: [:show, :destroy]

  def index
    @meetings = Meeting.all
    @meetings = @meetings.where(status: params[:status]) if params[:status].present?
    @meetings = @meetings.where(user_id: params[:user_id]) if params[:user_id].present?
    @meetings = @meetings.where('start_time >= ?', params[:start_date]) if params[:start_date].present?
    @meetings = @meetings.order(start_time: :desc)
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.update(status: 'canceled')
    redirect_to admin_meetings_path, notice: 'Meeting canceled.'
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
