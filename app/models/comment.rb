class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meeting
  has_rich_text :content

  validates :content, presence: true, length: { maximum: 1000 }
end