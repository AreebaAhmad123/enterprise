class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting
  before_action :set_payment, only: [:show, :refund]

  def new
    @payment = @meeting.build_payment(
      user: current_user,
      amount: @meeting.consultant.hourly_rate, # assuming consultant has hourly_rate
      currency: 'usd',
      status: 'pending'
    )
  end

  def create
    @payment = @meeting.build_payment(
      user: current_user,
      amount: @meeting.consultant.hourly_rate,
      currency: 'usd',
      status: 'pending'
    )

    if @payment.save
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: @payment.currency,
            product_data: { name: "Consulting Session: #{@meeting.title}" },
            unit_amount: (@payment.amount * 100).to_i
          },
          quantity: 1
        }],
        mode: 'payment',
        success_url: meeting_payment_success_url(@meeting, @payment),
        cancel_url: meeting_payment_cancel_url(@meeting, @payment)
      )

      @payment.update(stripe_session_id: session.id)
      redirect_to session.url, allow_other_host: true
    else
      flash.now[:alert] = 'Failed to create payment.'
      render :new, status: :unprocessable_entity
    end
  end

  # You can implement webhook or a success action after payment confirmation from Stripe
  def success
    # Find payment by stripe_session_id or params, mark as succeeded, etc.
  end

  def cancel
    # Handle cancellation logic if needed
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
end
