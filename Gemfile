source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'pg'
gem 'haml-rails'
gem 'stripe'
gem 'devise'
gem 'omniauth-facebook'

gem 'will_paginate'
gem 'filepicker-rails'
gem 'balanced'
gem 'ajaxful_rating', :branch => 'rails3', :git => "git://github.com/edgarjs/ajaxful-rating.git"
gem 'thin'
gem 'settingslogic'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :test, :development do
  gem 'debugger'
  gem 'zeus', :require => false
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '~> 2.0.2'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
end

ruby '1.9.3'
