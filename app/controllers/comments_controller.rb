# class CommentsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_session
#   before_action :set_comment, only: [:destroy]

#   def create
#     @comment = @session.comments.build(comment_params)
#     @comment.user = current_user

#     if @comment.save
#       respond_to do |format|
#         format.html { redirect_to @session, notice: 'Comment was successfully added.' }
#         format.turbo_stream
#       end
#     else
#       respond_to do |format|
#         format.html { redirect_to @session, alert: 'Error adding comment.' }
#         format.turbo_stream { render turbo_stream: turbo_stream.replace('comment_form', partial: 'comments/form', locals: { comment: @comment, session: @session }) }
#       end
#     end
#   end

#   def destroy
#     if @comment.user == current_user || current_user.admin?
#       @comment.destroy
#       respond_to do |format|
#         format.html { redirect_to @session, notice: 'Comment was successfully deleted.' }
#         format.turbo_stream
#       end
#     else
#       redirect_to @session, alert: 'You are not authorized to delete this comment.'
#     end
#   end

#   private

#   def set_session
#     @session = Session.find(params[:session_id])
#   end

#   def set_comment
#     @comment = @session.comments.find(params[:id])
#   end

#   def comment_params
#     params.require(:comment).permit(:content)
#   end
# end
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting

  def create
    @comment = @meeting.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @meeting, notice: 'Comment added.' }
        format.js   # For AJAX
      end
    else
      render 'meetings/show', status: :unprocessable_entity
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