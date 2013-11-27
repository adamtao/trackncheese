Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['OMNIAUTH_TWITTER_KEY'], ENV['OMNIAUTH_TWITTER_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :soundcloud, ENV['SOUNDCLOUD_CLIENT_ID'], ENV['SOUNDCLOUD_SECRET']
  provider :gplus, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET'], scope: 'userinfo.email, userinfo.profile'
  provider :identity, on_failed_registration: lambda { |env|    
    IdentitiesController.action(:new).call(env)
  }
end

# Handle bad logins in dev
#OmniAuth.config.on_failure = Proc.new { |env|
#  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
#}

if Rails.env.test?
	OmniAuth.config.test_mode = true
end