# config/initializers/auth0.rb
# frozen_string_literal: true

AUTH0_CONFIG = Rails.application.config_for(:auth0)
Rails.logger.debug "AUTH0_CONFIG: #{AUTH0_CONFIG.inspect}"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    AUTH0_CONFIG['auth0_client_id'],
    AUTH0_CONFIG['auth0_client_secret'],
    AUTH0_CONFIG['auth0_domain'],
    callback_path: AUTH0_CONFIG['auth0_callback_path'],
    authorize_params: {
      audience: AUTH0_CONFIG['auth0_audience'],
      scope: 'openid profile email',
      state: SecureRandom.uuid
    }
  )
end

OmniAuth.config.on_failure = proc { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}