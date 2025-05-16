module SessionsHelper
  def session_status_color(session)
    case session.status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'confirmed'
      'bg-green-100 text-green-800'
    when 'cancelled'
      'bg-red-100 text-red-800'
    when 'completed'
      'bg-gray-100 text-gray-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end 