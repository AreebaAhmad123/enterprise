class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :pay, :process_payment, :cancel]
  before_action :ensure_client, only: [:new, :create, :pay, :process_payment]
  before_action :authorize_cancellation, only: [:cancel]
  before_action :set_user_and_consultants, only: [:new, :create]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @meetings = @user.client_meetings.or(@user.consultant_meetings)

    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @meetings = @meetings.for_calendar(start_date, end_date)
      rescue ArgumentError
        flash[:alert] = 'Invalid date range.'
        @meetings = Meeting.none
      end
    end

    # Ensure @meetings is never nil
    @meetings ||= Meeting.none
  end

  def new
    @meeting = @user.client_meetings.build
    @meeting.start_time = params[:date] if params[:date].present?
  end

  def create
    @meeting = @user.client_meetings.build(meeting_params)
    
    # Prevent consultants from booking with themselves
    if @meeting.consultant_id == @meeting.client_id
      flash.now[:alert] = "A consultant cannot book a meeting with themselves"
      render :new, status: :unprocessable_entity
      return
    end

    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully booked.'
    else
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
    if request.get? || request.head?
      render :cancel
    else
      begin
        if @meeting.update(meeting_params.merge(status: 'cancelled'))
          MeetingMailer.cancellation_notification(@meeting, current_user).deliver_later
          redirect_to user_meetings_path(current_user), notice: 'Meeting was successfully cancelled.'
        else
          render :cancel, status: :unprocessable_entity
        end
      rescue RedisClient::CannotConnectError => e
        Rails.logger.error("Redis connection failed: #{e.message}")
        flash[:alert] = 'Unable to queue cancellation email due to server issue. Meeting was cancelled.'
        redirect_to user_meetings_path(current_user)
      end
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
    rescue Stripe::AuthenticationError => e
      flash[:alert] = "Stripe authentication failed: #{e.message}"
      render :pay, status: :unprocessable_entity
    rescue => e
      flash[:alert] = "Payment failed: #{e.message}"
      render :pay, status: :unprocessable_entity
    end
  end

  def export_csv
    return redirect_to root_path, alert: 'Only consultants can export meetings.' unless current_user.consultant?
    @meetings = Meeting.all
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"meetings-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def set_user_and_consultants
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @consultants = User.where("consultant_role = ? OR role = ?", true, 'admin').order(:email)
    @available_slots = generate_available_slots
  end

  def meeting_params
    params.require(:meeting).permit(
      :title, 
      :description, 
      :start_time, 
      :duration, 
      :consultant_id, 
      :cancellation_reason
    )
  end

  def ensure_client
    redirect_to root_path, alert: 'Only clients can perform this action.' unless current_user.client?
  end

  def authorize_cancellation
    unless @meeting.client == current_user || @meeting.consultant == current_user
      redirect_to @meeting, alert: 'You are not authorized to cancel this meeting.'
    end
  end

  def generate_available_slots
    start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    end_date = start_date + 7.days
    slots = []
    current_time = Time.current.in_time_zone('Asia/Karachi')
    
    (start_date..end_date).each do |day|
      (9..17).each do |hour| # 9 AM to 5 PM
        [0, 30].each do |minute| # 30-minute increments
          slot = day.to_time.change(hour: hour, min: minute).in_time_zone('Asia/Karachi')
          if slot > current_time && Meeting.slot_available?(slot, @consultants.pluck(:id))
            slots << slot
          end
        end
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