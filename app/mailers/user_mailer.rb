class UserMailer < ApplicationMailer
  def payment_confirmation(user, meeting)
    @user = user
    @meeting = meeting
    mail(to: @user.email, subject: 'Payment Confirmation for Your Session')
  end
end