class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization
  before_action :set_all_units

  private

  def set_all_units
    @all_units = Unit.all.order(:name)
  end
  # Pundit: allow-list approach


  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  private

  def skip_pundit?
        puts "DEBUG: skip_pundit? -> #{devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/} (devise_controller? -> #{devise_controller?})"
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
