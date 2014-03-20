module ApplicationHelper
  def nav_active ctrl
    controller.controller_name == ctrl ? "active" : ""
  end
end
