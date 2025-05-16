validates :content, length: { maximum: 1000 }

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meeting
  validates :content, presence: true
end
