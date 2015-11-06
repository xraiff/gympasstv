source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.4', git: 'https://github.com/rails/rails.git', branch: '4-2-stable'

gem 'mysql2'

gem 'fileutils'

group :production, :staging do
  gem 'passenger'
end

# auth
gem 'devise'
gem 'devise-async'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'font-awesome-sass-rails'


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer'
gem 'libv8'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'active_model_serializers'

gem 'responders'

gem 'builder'  # XmlBuilder

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'aws-sdk'
gem 'sidekiq'

gem 'figaro' # application.yml => system Environment variables

group :development, :test do
  gem 'rspec-rails'
end

