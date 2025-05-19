class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting

  def create
    @comment = @meeting.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @meeting, notice: 'Comment was successfully added.' }
        format.json { render json: { comment: { id: @comment.id, content: @comment.content, user: @comment.user.email, created_at: @comment.created_at.strftime('%b %d, %Y %I:%M %p') } }, status: :created }
      else
        format.html { render 'meetings/show', status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
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