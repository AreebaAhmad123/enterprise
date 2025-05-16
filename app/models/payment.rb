class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :meeting
  validates :amount, :status, presence: true
  validates :status, inclusion: { in: %w[pending succeeded failed] }
end