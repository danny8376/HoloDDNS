source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', :group => [:development, :test]

# Postgres
gem 'pg', :group => :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Compass
#gem 'compass-rails', '~> 1.1.7'

# Bootstrap
gem 'bootstrap-sass', '~> 3.1.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Slim
gem 'slim-rails', '~> 2.1.2'

# Devise
gem 'devise', '~> 3.2.4'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# async wrappers
gem 'eventmachine'
gem 'em-postgresql-adapter', :group => :production, :github => 'leftbee/em-postgresql-adapter'
gem 'rack-fiber_pool', :require => 'rack/fiber_pool'
gem 'em-smtp', :github => 'danny8376/em-smtp'
#gem 'em-http-request'
gem 'em-synchrony', :require => ['em-synchrony',
#                                 'em-synchrony/em-http',
                                 'em-synchrony/em-memcache',
                                 'em-synchrony/activerecord']

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Thin
gem 'thin'

# RubyDNS
gem 'rubydns'

# Dalli for session with memcache
gem 'dalli'

# Dalli with fiber settings
gem 'connection_pool'
