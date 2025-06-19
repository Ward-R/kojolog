class PagesController < ApplicationController
  def home
    @welcome_message = "Hello, #{current_user.first_name}!" if current_user
    @recent_logs = Log.order(created_at: :desc).limit(5)
  end
end
