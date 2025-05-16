class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_session
  before_action :set_payment, only: [:show, :process_payment, :refund]

  def new
    @payment = @session.build_payment(
      user: current_user,
      amount: @session.consultant.hourly_rate,
      currency: 'usd'
    )
  end

  def create
    @payment = @session.build_payment(payment_params)
    @payment.user = current_user

    if @payment.save
      redirect_to new_session_payment_process_path(@session, @payment)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def process_payment
    if @payment.process_payment(params[:payment_method_id])
      redirect_to session_path(@session), notice: 'Payment was successful!'
    else
      redirect_to new_session_payment_process_path(@session, @payment), alert: 'Payment failed. Please try again.'
    end
  end

  def refund
    if @payment.refund
      redirect_to session_path(@session), notice: 'Payment was successfully refunded.'
    else
      redirect_to session_path(@session), alert: 'Refund failed. Please try again.'
    end
  end

  private

  def set_session
    @session = Session.find(params[:session_id])
  end

  def set_payment
    @payment = @session.payment
  end

  def payment_params
    params.require(:payment).permit(:amount, :currency)
  end
end 