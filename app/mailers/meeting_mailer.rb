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

  def cancellation_notification(meeting, user)
    @meeting = meeting
    @user = user
    mail(to: [@meeting.client.email, @meeting.consultant.email], subject: "Meeting ##{meeting.id} Cancelled")
  end
end