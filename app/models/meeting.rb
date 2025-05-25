class Meeting < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :consultant, class_name: 'User', foreign_key: 'consultant_id'
  has_many :comments, dependent: :destroy

  validates :title, :start_time, :duration, :client_id, :consultant_id, presence: true
  validates :status, inclusion: { in: %w[scheduled cancelled completed] }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 30, less_than_or_equal_to: 120 }, allow_nil: true
  validates :cancellation_reason, presence: true, if: :cancelled?
  validate :client_and_consultant_cannot_be_same

  scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
  scope :past, -> { where("start_time <= ?", Time.current).order(:start_time) }
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
    start_time.in_time_zone('Asia/Karachi').to_date
  end

  # Check if a time slot is available for booking
  def self.slot_available?(date, time)
    time_slot = Time.zone.parse("#{date} #{time}").in_time_zone('Asia/Karachi')
    return false if time_slot < Time.current.in_time_zone('Asia/Karachi')
    
    # Check if there's an active meeting at this time
    where(start_time: time_slot).where.not(status: 'cancelled').none?
  end

  # Check if a date has any available slots
  def self.date_has_available_slots?(date)
    date = date.to_date
    return false if date < Time.current.in_time_zone('Asia/Karachi').to_date
    
    # Check if there are any cancelled meetings or no meetings at all
    cancelled_meetings = where("DATE(start_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Karachi') = ?", date)
                        .where(status: 'cancelled')
    
    no_meetings = where("DATE(start_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Karachi') = ?", date)
                  .where.not(id: cancelled_meetings.select(:id))
                  .none?
    
    cancelled_meetings.exists? || no_meetings
  end

  private

  def client_and_consultant_cannot_be_same
    if client_id == consultant_id
      errors.add(:base, "A consultant cannot book a meeting with themselves")
    end
  end
end