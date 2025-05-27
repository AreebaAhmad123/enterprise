class Meeting < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :consultant, class_name: 'User', foreign_key: 'consultant_id'
  has_many :comments, dependent: :destroy

  validates :title, :start_time, :duration, :client_id, :consultant_id, presence: true
  validates :status, inclusion: { in: %w[scheduled cancelled completed] }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 30, less_than_or_equal_to: 120 }, allow_nil: true
  validates :cancellation_reason, presence: true, if: :cancelled?
  validate :client_and_consultant_cannot_be_same
  validate :not_on_sunday

  scope :upcoming, -> { 
    current_time = Time.current.in_time_zone('Asia/Karachi')
    Rails.logger.debug "Meeting.upcoming scope - Current time (UTC): #{current_time.utc}"
    Rails.logger.debug "Meeting.upcoming scope - Current time (PKT): #{current_time}"
    where("start_time > ?", current_time).order(:start_time) 
  }
  
  scope :past, -> { 
    current_time = Time.current.in_time_zone('Asia/Karachi')
    where("start_time <= ?", current_time).order(:start_time) 
  }
  
  scope :active, -> { where(status: ['scheduled', 'completed']) } # For calendar filtering
  
  # Calendar scopes
  scope :for_calendar, ->(start_date, end_date) {
    where("DATE(start_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Karachi') BETWEEN ? AND ?", start_date, end_date)
  }

  def end_time
    start_time + duration.minutes if start_time && duration
  end

  def cancelled?
    status == 'cancelled'
  end

  # Helper method for calendar display
  def calendar_date
    # Convert to Asia/Karachi timezone for consistent display
    start_time.in_time_zone('Asia/Karachi').to_date
  end

  # Check if a time slot is available for booking
  def self.slot_available?(date, time)
    time_slot = Time.zone.parse("#{date} #{time}").in_time_zone('Asia/Karachi')
    current_time = Time.current.in_time_zone('Asia/Karachi')
    Rails.logger.debug "Meeting.slot_available? - Time slot (UTC): #{time_slot.utc}"
    Rails.logger.debug "Meeting.slot_available? - Time slot (PKT): #{time_slot}"
    Rails.logger.debug "Meeting.slot_available? - Current time (UTC): #{current_time.utc}"
    Rails.logger.debug "Meeting.slot_available? - Current time (PKT): #{current_time}"
    return false if time_slot < current_time
    return false if time_slot.sunday?
    
    # Check if there's an active meeting at this time
    where(start_time: time_slot).where.not(status: 'cancelled').none?
  end

  # Check if a date has any available slots
  def self.date_has_available_slots?(date)
    date = date.to_date
    current_date = Time.current.in_time_zone('Asia/Karachi').to_date
    return false if date < current_date
    return false if date.sunday?

    # Check if there are any available slots in the working hours (9 AM to 5 PM)
    working_hours = (9..17).to_a
    working_minutes = [0, 30]
    
    working_hours.each do |hour|
      working_minutes.each do |minute|
        time_slot = date.to_time.change(hour: hour, min: minute).in_time_zone('Asia/Karachi')
        return true if slot_available?(date, time_slot.strftime('%H:%M'))
      end
    end
    
    false
  end

  private

  def client_and_consultant_cannot_be_same
    if client_id == consultant_id
      errors.add(:base, "Client and consultant cannot be the same person")
    end
  end

  def not_on_sunday
    if start_time&.sunday?
      errors.add(:start_time, "cannot be scheduled on Sunday")
    end
  end
end