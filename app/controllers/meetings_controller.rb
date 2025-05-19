class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :pay, :process_payment, :cancel]
  before_action :ensure_client, only: [:new, :create, :pay, :process_payment, :cancel]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @meetings = if current_user.admin? && params[:filter_user_id].present?
                  User.find(params[:filter_user_id]).client_meetings.or(User.find(params[:filter_user_id]).consultant_meetings)
                else
                  @user.client_meetings.or(@user.consultant_meetings)
                end
    if params[:start_date].present? && params[:end_date].present?
      begin
        @meetings = @meetings.where(start_time: params[:start_date]..params[:end_date])
      rescue ArgumentError
        flash[:alert] = 'Invalid date range.'
        @meetings = @meetings.none
      end
    end
  end

  def new
    @user = User.find(params[:user_id])
    @meeting = @user.client_meetings.build
    @meeting.start_time = params[:date] if params[:date].present?
    @consultants = User.where(role: 'admin').order(:email)
    @available_slots = generate_available_slots
  end

  def create
    @user = User.find(params[:user_id])
    @meeting = @user.client_meetings.build(meeting_params)
    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully booked.'
    else
      @consultants = User.where(role: 'admin').order(:email)
      @available_slots = generate_available_slots
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: 'Meeting was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meeting.destroy
    redirect_to user_meetings_path(@meeting.client), notice: 'Meeting was successfully deleted.'
  end

  def cancel
    if @meeting.client == current_user && @meeting.update(status: 'cancelled')
      redirect_to user_meetings_path(current_user), notice: 'Meeting was successfully cancelled.'
    else
      redirect_to @meeting, alert: 'Unable to cancel meeting.'
    end
  end

  def pay
  end

  def process_payment
    begin
      charge = Stripe::Charge.create(
        amount: 5000, # $50.00
        currency: 'usd',
        source: params[:stripeToken],
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

  def export_csv
    return redirect_to root_path, alert: 'Only admins can export meetings.' unless current_user.admin?
    @meetings = Meeting.all
    respond_to do |format|
      format.csv do
        send_data generate_csv, filename: "meetings-#{Date.today}.csv"
      end
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :description, :start_time, :duration, :consultant_id)
  end

  def ensure_client
    redirect_to root_path, alert: 'Only clients can perform this action.' unless current_user.client?
  end

  def generate_available_slots
    start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    end_date = start_date + 7.days
    slots = []
    (start_date..end_date).each do |day|
      (9..17).each do |hour| # 9 AM to 5 PM
        slot = day.to_time.change(hour: hour, min: 0)
        slots << slot unless Meeting.exists?(start_time: slot)
      end
    end
    slots
  end

  def generate_csv
    require 'csv'
    CSV.generate(headers: true) do |csv|
      csv << ['Title', 'Client', 'Consultant', 'Start Time', 'Duration (minutes)', 'Status']
      @meetings.each do |meeting|
        csv << [
          meeting.title,
          meeting.client&.email || 'Not assigned',
          meeting.consultant&.email || 'Not assigned',
          meeting.start_time.strftime('%Y-%m-%d %H:%M'),
          meeting.duration,
          meeting.status
        ]
      end
    end
  end
end