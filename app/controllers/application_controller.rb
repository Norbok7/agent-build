class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :assign_user_id

  private

  def assign_user_id
    session[:user_id] ||= SecureRandom.uuid
  end
end
