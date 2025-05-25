class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting
  before_action :set_payment, only: [:show, :refund]
  before_action :ensure_client, only: [:new, :create]

  def new
    @payment = @meeting.build_payment(
      user: current_user,
      amount: calculate_amount,
      currency: 'usd',
      status: 'pending'
    )
  end

  def create
    @payment = @meeting.build_payment(
      user: current_user,
      amount: calculate_amount,
      currency: 'usd',
      status: 'pending'
    )

    if @payment.save
      begin
        # Create a PaymentIntent with the order amount and currency
        payment_intent = Stripe::PaymentIntent.create(
          amount: (@payment.amount * 100).to_i, # Convert to cents
          currency: @payment.currency,
          payment_method_types: ['card'],
          metadata: {
            meeting_id: @meeting.id,
            payment_id: @payment.id
          }
        )

        @payment.update!(
          stripe_payment_intent_id: payment_intent.id,
          card_brand: payment_intent.payment_method_details&.card&.brand,
          card_last4: payment_intent.payment_method_details&.card&.last4
        )

        render json: {
          clientSecret: payment_intent.client_secret
        }
      rescue Stripe::StripeError => e
        @payment.update!(
          status: 'failed',
          error_message: e.message
        )
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      status 400
      return
    end

    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
      
      if payment
        payment.update!(
          status: 'completed',
          card_brand: payment_intent.payment_method_details&.card&.brand,
          card_last4: payment_intent.payment_method_details&.card&.last4
        )
        
        # Update meeting status
        payment.meeting.update!(status: 'completed')
        
        # Send confirmation email
        MeetingMailer.payment_confirmation(payment.user, payment.meeting).deliver_later
      end
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
      payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
      
      if payment
        payment.update!(
          status: 'failed',
          error_message: payment_intent.last_payment_error&.message
        )
      end
    end

    render json: { status: 'success' }
  end

  def refund
    if @payment.refund
      redirect_to meeting_path(@meeting), notice: 'Payment was successfully refunded.'
    else
      redirect_to meeting_path(@meeting), alert: 'Refund failed. Please try again.'
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end

  def set_payment
    @payment = @meeting.payment
  end

  def ensure_client
    redirect_to root_path, alert: 'Only clients can perform this action.' unless current_user.client?
  end

  def calculate_amount
    # Calculate amount based on meeting duration and consultant's rate
    duration_in_hours = @meeting.duration / 60.0
    @meeting.consultant.hourly_rate * duration_in_hours
  end
end
