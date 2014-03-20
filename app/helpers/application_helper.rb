module ApplicationHelper
  def nav_active ctrl
    controller.controller_name == ctrl ? "active" : ""
  end
  def current_locale? locale
    locale = locale.to_sym unless locale.is_a? Symbol
    I18n.locale == locale
  end
end
