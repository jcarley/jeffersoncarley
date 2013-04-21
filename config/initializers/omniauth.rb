OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new do |env|
  "SessionsController".constantize.action(:failure).call(env)
  #this will invoke the omniauth_failure action in UsersController.
end

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, Figaro.env.twitter_key, Figaro.env.twitter_secret

  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {access_type: 'online', approval_prompt: '', :client_options => {:ssl => {:verify => false}}}

  # provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'], {:client_options => {:ssl => {:verify => false}}}

  #provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {access_type: 'online', approval_prompt: ''}
  #provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {access_type: 'online', approval_prompt: '', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}
end
