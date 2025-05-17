class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception, unless: -> { auth0_callback? }
  protect_from_forgery with: :exception, unless: -> { request.path.start_with?('/auth/auth0') }
  private
  
  def auth0_callback?
    request.path == '/auth/auth0/callback'
  end
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def require_login
    return if current_user
    redirect_to '/auth/auth0?prompt=login'
  end
  def decoded_id_token
    return unless session[:credentials]
    jwks_raw = Net::HTTP.get URI("https://#{AUTH0_CONFIG['auth0_domain']}/.well-known/jwks.json")
    jwks_keys = JSON.parse(jwks_raw)['keys']
    jwks = JWT::JWK::Set.new(jwks_keys)
    JWT.decode(session[:credentials][:id_token], nil, true, {
      algorithms: ['RS256'],
      jwks: jwks,
      aud: AUTH0_CONFIG['auth0_audience'],
      verify_aud: true
    })[0].deep_symbolize_keys
  rescue JWT::DecodeError
    nil
  end
end