require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/static_assets'

require './config/secrets'
set :root, "#{File.dirname(__FILE__)}/app"
I18n.load_path << Dir.glob("#{File.dirname(__FILE__)}/config/locales/*.yml")

require_all 'app'

def layout sym
  slim :app_layout do
    slim sym
  end
end

def nav_active ctrl
  #controller.controller_name == ctrl ? "active" : ""
  ""
end
def current_locale? locale
  locale = locale.to_sym unless locale.is_a? Symbol
  I18n.locale == locale
end


get '/' do
  #"Hello OwO"
  #slim :index
  layout :index
end

get '/records/' do
  @record = Record.first
end
