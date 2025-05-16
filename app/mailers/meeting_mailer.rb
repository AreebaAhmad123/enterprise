class MeetingMailer < ApplicationMailer
  def booking_confirmation(user, meeting)
    @user = user
    @meeting = meeting
    mail(to: @user.email, subject: 'Meeting Confirmation')
  end

  def payment_receipt(user, payment)
    @user = user
    @payment = payment
    mail(to: @user.email, subject: 'Payment Receipt')
  end
end