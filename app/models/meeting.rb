class Meeting < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one :payment, dependent: :destroy
  validates :start_time, :duration, :status, presence: true
  validates :status, inclusion: { in: %w[scheduled canceled completed] }
end