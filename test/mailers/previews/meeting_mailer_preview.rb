class MeetingMailerPreview < ActionMailer::Preview
  def booking_confirmation
    MeetingMailer.booking_confirmation(User.first, Meeting.first)
  end

  def payment_receipt
    MeetingMailer.payment_receipt(User.first, Payment.first)
  end
end