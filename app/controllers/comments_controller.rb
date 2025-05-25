class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting

  def create
    @comment = @meeting.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @meeting, notice: 'Comment was successfully added.'
    else
      redirect_to @meeting, alert: 'Failed to add comment.'
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end