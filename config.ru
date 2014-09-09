require 'bundler'
Bundler.require(:default)
require './app'

require 'sass/plugin/rack'

use Sass::Plugin::Rack
use Rack::Coffee, root: 'public', urls: '/javascripts'

run Sinatra::Application
