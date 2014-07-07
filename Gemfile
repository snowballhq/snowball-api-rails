source 'http://rubygems.org'

ruby '2.1.2'

gem 'rails'
gem 'pg'
gem 'unicorn'
gem 'jbuilder'
gem 'paperclip'
gem 'fog'
gem 'zencoder'
gem 'kaminari'
gem 'devise'
gem 'urbanairship'
gem 'koala'
gem 'phony_rails'
gem 'newrelic_rpm'
gem 'rollbar'

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rubocop'
  gem 'guard-rspec'
  gem 'better_errors'
  gem 'dotenv-rails'
end

group :development do
  gem 'zencoder-fetcher'
end

group :production do
  gem 'rails_12factor'
end

group :production, :development do
  gem 'rails_stdout_logging'
end
