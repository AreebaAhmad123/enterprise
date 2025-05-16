class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @meetings = @user.meetings
  end

  def show
  end

  def new
    @meeting = @user.meetings.build
  end

  def create
    @meeting = @user.meetings.build(meeting_params)
    if @meeting.save
      redirect_to user_meetings_path(@user), notice: 'Meeting scheduled.'
    else
      render :new
    end
  end

  def destroy
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