class Auth0Controller < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback] # Disable CSRF for callback

  def login
  # Use redirect_post for proper CSRF handling
  redirect_post("https://#{ENV['AUTH0_DOMAIN']}/authorize?" + {
    client_id: ENV['AUTH0_CLIENT_ID'],
    response_type: 'code',
    redirect_uri: "#{request.base_url}/auth/auth0/callback",
    scope: 'openid profile email',
    audience: ENV['AUTH0_AUDIENCE'],
    state: SecureRandom.hex(16),
    screen_hint: params[:screen_hint]
  }.to_query, options: {authenticity_token: 'auto'})
end

  def callback
    auth_info = request.env['omniauth.auth']
    
    # Find or create user from Auth0 data
    user = User.find_or_create_by(email: auth_info['info']['email']) do |u|
      u.auth0_id = auth_info['uid']
      u.name = auth_info['info']['name']
      u.nickname = auth_info['info']['nickname']
      u.picture = auth_info['info']['image']
      # Set other fields as needed
    end

    # Store user ID in session
    session[:auth0_user_id] = user.auth0_id
    session[:credentials] = {
      id_token: auth_info['credentials']['id_token'],
      access_token: auth_info['credentials']['token']
    }

    redirect_to profile_path
  end

  def failure
    @error_msg = request.params['message']
    render 'auth0/failure'
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG['auth0_client_id']
    }

    URI::HTTPS.build(
      host: AUTH0_CONFIG['auth0_domain'],
      path: '/v2/logout',
      query: request_params.to_query
    ).to_s
  end
end