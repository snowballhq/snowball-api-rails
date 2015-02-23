# Based off of production
require Rails.root.join('config/environments/production')

Rails.Application.configure do
  # Settings specified here will take precedence over those in config/application.rb and config/environments/production.rb.

  # The default base URL to use when mailing users
  config.action_mailer.default_url_options = { host: 'http://s.snowball.is' }
end
