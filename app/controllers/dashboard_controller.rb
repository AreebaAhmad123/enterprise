class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_role

  def index
    if current_user.consultant?
      set_consultant_data
      render 'dashboard/consultant'
    else
      set_client_data
      render 'dashboard/client'
    end
  end

  private

  def check_user_role
    unless current_user.consultant? || current_user.client?
      redirect_to root_path, alert: "You don't have access to this page."
    end
  end

  def set_consultant_data
    # Today's sessions
    @today_sessions = current_user.consultant_meetings
                                 .where(start_time: Time.current.beginning_of_day..Time.current.end_of_day)
                                 .order(start_time: :asc)
    @today_sessions_count = @today_sessions.count

    # Upcoming sessions
    @upcoming_sessions = current_user.consultant_meetings
                                   .where('start_time > ?', Time.current)
                                   .order(start_time: :asc)
    @upcoming_sessions_count = @upcoming_sessions.count

    # Client statistics
    @total_clients = current_user.consultant_meetings
                                .distinct
                                .pluck(:client_id)
                                .count

    # Earnings
    @total_earnings = current_user.consultant_meetings
                                 .where(status: 'completed')
                                 .sum(:amount)

    # Session statistics
    @completed_sessions_count = current_user.consultant_meetings
                                          .where(status: 'completed')
                                          .count
    @cancelled_sessions_count = current_user.consultant_meetings
                                          .where(status: 'cancelled')
                                          .count
    @average_session_duration = current_user.consultant_meetings
                                          .where(status: 'completed')
                                          .average(:duration)
                                          .to_i
    @total_session_hours = (@completed_sessions_count * @average_session_duration) / 60.0

    # Recent activity
    @recent_activity = current_user.consultant_meetings
                                  .order(created_at: :desc)
                                  .limit(5)
                                  .map do |meeting|
      {
        type: meeting.status == 'cancelled' ? 'cancellation' : 'session',
        description: "#{meeting.title} with #{meeting.client.full_name}",
        created_at: meeting.created_at
      }
    end
  end

  def set_client_data
    # Initialize all variables to prevent nil errors
    @upcoming_sessions = []
    @upcoming_sessions_count = 0
    @completed_sessions_count = 0
    @total_spent = 0
    @recent_activity = []

    # Upcoming sessions
    @upcoming_sessions = current_user.client_meetings
                                   .where('start_time > ?', Time.current)
                                   .order(start_time: :asc)
    @upcoming_sessions_count = @upcoming_sessions.count

    # Completed sessions
    @completed_sessions_count = current_user.client_meetings
                                          .where(status: 'completed')
                                          .count

    # Total spent
    @total_spent = current_user.client_meetings
                              .where(status: 'completed')
                              .sum(:amount)

    # Recent activity
    @recent_activity = current_user.client_meetings
                                  .order(created_at: :desc)
                                  .limit(5)
                                  .map do |meeting|
      {
        type: meeting.status == 'cancelled' ? 'cancellation' : 'session',
        description: "#{meeting.title} with #{meeting.consultant.full_name}",
        created_at: meeting.created_at
      }
    end
  end
end 