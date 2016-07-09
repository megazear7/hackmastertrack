class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :require_login

  before_filter :check_if_devise

  before_action :set_current_character

  def set_current_character
    if params[:character_id] and Character.exists?(params[:character_id])
      @current_character ||= Character.find(params[:character_id])
      cookies[:character_id] = params[:character_id]
    elsif cookies[:character_id] and Character.exists?(cookies[:character_id])
      @current_character ||= Character.find(cookies[:character_id])
    end
  end

  private
    def check_if_devise
      if params[:controller].include? "devise/registrations" and params[:action].include? "create"
        redirect_to new_user_registration_path, alert: "invalid registration key" unless params[:user][:creation_key] == "dontopenthecrypt"
      end
    end

    def require_login
      if not current_user and not params[:controller].include? "devise"
        redirect_to new_user_session_path
      end
    end
end
