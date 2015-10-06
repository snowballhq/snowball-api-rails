source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails'
gem 'pg'
gem 'jbuilder'
gem 'puma'
gem 'phony_rails'
gem 'paperclip'
gem 'aws-sdk', '<2.0'
gem 'bcrypt'
gem 'devise'
gem 'newrelic_rpm'
gem 'httparty'

group :development, :test do
  gem 'spring'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'guard-rspec'
  gem 'dotenv-rails'
  gem 'fuubar'
end

group :test do
  gem 'webmock'
end

group :production, :staging do
  gem 'rails_12factor'
end
