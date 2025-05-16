class Session < ApplicationRecord
  belongs_to :user
  belongs_to :consultant, class_name: 'User'
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled completed] }
  
  validate :end_time_after_start_time
  validate :no_overlapping_sessions

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def no_overlapping_sessions
    return if start_time.blank? || end_time.blank?

    overlapping = Session.where(consultant_id: consultant_id)
                        .where.not(id: id)
                        .where('(start_time, end_time) OVERLAPS (?, ?)', start_time, end_time)
                        .exists?

    if overlapping
      errors.add(:base, "This time slot overlaps with an existing session")
    end
  end
end 