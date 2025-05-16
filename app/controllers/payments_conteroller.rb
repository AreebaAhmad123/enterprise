class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting

  def new
    @payment = @meeting.build_payment
  end

  def create
    @payment = @meeting.build_payment(user: current_user, amount: 100.00) # Example amount
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: { name: 'Consulting Session' },
          unit_amount: (@payment.amount * 100).to_i
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: root_url,
      cancel_url: new_user_meeting_payment_url(@meeting.user, @meeting)
    )
    @payment.stripe_charge_id = session.id
    @payment.status = 'succeeded'
    @payment.save
    redirect_to session.url, allow_other_host: true
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end
end