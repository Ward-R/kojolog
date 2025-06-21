class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
    after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?


  def index
    # home page logic
  end
  def home
    @welcome_message = "Hello, #{current_user.first_name}!" if current_user
    @recent_logs = Log.order(created_at: :desc).limit(5)
  end
end
