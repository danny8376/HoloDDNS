class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  protected

  def user_root_path
    records_path if defined? :records_path
  end

  def set_locale
    locale = params[:locale]
    I18n.locale = (locale and I18n.available_locales.include? locale.to_sym) ? locale : I18n.default_locale
  end


  def self.default_url_options(options={})
    return options if I18n.default_locale == I18n.locale
    options.merge!({ locale: I18n.locale })
  end
end
