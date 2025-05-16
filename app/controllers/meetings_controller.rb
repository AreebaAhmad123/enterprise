class MeetingsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @meetings = @user.meetings
    authorize @meetings
  end

  def show
    authorize @meeting
  end

  def new
    @meeting = @user.meetings.build
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @available_slots = Meeting.available_slots(@date)
    authorize @meeting
  end

  def create
    @meeting = @user.meetings.build(meeting_params)
    authorize @meeting
    if @meeting.save
      MeetingMailer.booking_confirmation(@user, @meeting).deliver_later
      redirect_to user_meetings_path(@user), notice: 'Meeting scheduled.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @meeting
    @meeting.update(status: 'canceled')
    redirect_to user_meetings_path(@user), notice: 'Meeting canceled.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_meeting
    @meeting = @user.meetings.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:start_time, :duration)
  end
end