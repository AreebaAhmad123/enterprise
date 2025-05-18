class MeetingsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :ensure_client, only: [:new, :create]

  def index
    @meetings = @user.client? ? @user.client_meetings.upcoming : @user.meetings
    authorize @meetings
  end

  def show
    authorize @meeting
  end

  def new
    @meeting = @user.meetings.build
    @consultants = User.where(role: "admin") # Admins act as consultants
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @available_slots = Meeting.available_slots(@date)
    authorize @meeting
  end

  def create
    @meeting = @user.meetings.build(meeting_params)
    authorize @meeting
    @meeting.client = @user
    if @meeting.save
      MeetingMailer.booking_confirmation(@user, @meeting).deliver_later
      redirect_to user_meetings_path(@user), notice: 'Meeting scheduled.'
    else
      @consultants = User.where(role: "admin")
      render :new, status: :unprocessable_entity
    end
  end
  def cancel
    @meeting = Meeting.find(params[:id])
    if @meeting.client == current_user && @meeting.status != "cancelled"
      @meeting.update(status: "cancelled")
      redirect_to meetings_path, notice: "Session cancelled."
    else
      redirect_to meetings_path, alert: "Unable to cancel session."
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
    params.require(:meeting).permit(:title, :description, :start_time, :end_time, :consultant_id, :duration)
  end

  def ensure_client
    redirect_to root_path, alert: "Only clients can perform this action." unless current_user.client?
  end
  def pay
end

def process_payment
  begin
    charge = Stripe::Charge.create(
      amount: 5000, # $50.00
      currency: 'usd',
      source: params[:stripe_token],
      description: "Payment for meeting #{@meeting.id}"
    )
    @meeting.update(status: 'completed')
    UserMailer.payment_confirmation(current_user, @meeting).deliver_later
    redirect_to @meeting, notice: 'Payment successful!'
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    render :pay, status: :unprocessable_entity
  end
end
end
