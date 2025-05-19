class Meeting < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :consultant, class_name: 'User', foreign_key: 'consultant_id'
  has_many :comments, dependent: :destroy

  validates :title, :start_time, :duration, :client_id, :consultant_id, presence: true
  validates :status, inclusion: { in: %w[scheduled cancelled completed] }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 30, less_than_or_equal_to: 120 }, allow_nil: true

  scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
  scope :past, -> { where("start_time <= ?", Time.current).order(:start_time) }

  def end_time
    start_time + duration.minutes if start_time && duration
  end
end