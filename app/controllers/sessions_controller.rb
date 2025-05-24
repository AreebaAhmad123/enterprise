# class SessionsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_session, only: [:show, :edit, :update, :destroy]
#   before_action :authorize_user, only: [:edit, :update, :destroy]

#   def index
#     @sessions = if current_user.admin?
#       Session.all
#     else
#       Session.where(user_id: current_user.id).or(Session.where(consultant_id: current_user.id))
#     end
#   end

#   def show
#     @comment = Comment.new
#     @comments = @session.comments.includes(:user).order(created_at: :desc)
#   end

#   def new
#     @session = Session.new
#   end

#   def create
#     @session = current_user.sessions.build(session_params)
#     @session.status = 'pending'

#     if @session.save
#       redirect_to @session, notice: 'Session was successfully created.'
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def edit
#   end

#   def update
#     if @session.update(session_params)
#       redirect_to @session, notice: 'Session was successfully updated.'
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     @session.destroy
#     redirect_to sessions_path, notice: 'Session was successfully cancelled.'
#   end

#   private

#   def set_session
#     @session = Session.find(params[:id])
#   end

#   def session_params
#     params.require(:session).permit(:title, :description, :start_time, :end_time, :consultant_id)
#   end

#   def authorize_user
#     unless current_user.admin? || @session.user_id == current_user.id
#       redirect_to sessions_path, alert: 'You are not authorized to perform this action.'
#     end
#   end
# end 
class SessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_session, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    if current_user.admin?
      case session[:acting_role]
      when 'consultant'
        @sessions = Session.where(consultant_id: current_user.id)
      when 'admin', nil
        @sessions = Session.all
      end
    else
      @sessions = Session.where(user_id: current_user.id).or(Session.where(consultant_id: current_user.id))
    end
  end

  def show
    @comment = Comment.new
    @comments = @session.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @session = Session.new
  end

  def create
    @session = current_user.sessions.build(session_params)
    @session.status = 'pending'

    if @session.save
      redirect_to @session, notice: 'Session was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @session.update(session_params)
      redirect_to @session, notice: 'Session was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    redirect_to sessions_path, notice: 'Session was successfully cancelled.'
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :description, :start_time, :end_time, :consultant_id)
  end

  def authorize_user
    return if current_user.admin?

    unless @session.user_id == current_user.id || @session.consultant_id == current_user.id
      redirect_to sessions_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
