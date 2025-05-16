validates :content, length: { maximum: 1000 }

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :session

  validates :content, presence: true

  after_create_commit :broadcast_comment

  private

  def broadcast_comment
    SessionChannel.broadcast_to(
      session,
      {
        html: ApplicationController.renderer.render(
          partial: 'comments/comment',
          locals: { comment: self }
        ),
        user_id: user_id
      }
    )
  end
end
