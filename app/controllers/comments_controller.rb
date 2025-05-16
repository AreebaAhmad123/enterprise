class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting

  def create
    @comment = @meeting.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.js # Render comments/create.js.erb
      end
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
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