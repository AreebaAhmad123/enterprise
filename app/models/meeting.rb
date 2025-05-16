class Meeting < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one :payment, dependent: :destroy
  validates :start_time, :duration, :status, presence: true
  validates :status, inclusion: { in: %w[scheduled canceled completed] }
  validates :duration, numericality: { greater_than: 0, less_than_or_equal_to: 120 }
  validates :start_time, uniqueness: { scope: :user_id, message: 'Slot already booked' }

  def self.available_slots(date)
    slots = []
    start_hour = 9 # 9 AM
    end_hour = 17 # 5 PM
    (start_hour..end_hour).each do |hour|
      slot_time = date.in_time_zone.beginning_of_day + hour.hours
      next if exists?(start_time: slot_time)
      slots << slot_time
    end
    slots
  end
end