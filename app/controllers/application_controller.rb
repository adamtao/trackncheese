class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        @current_user ||= User.new # There's always a user whether or not they're logged in
        if cookies.permanent.signed[:my_projects]
          @current_user.projects += cookies.permanent.signed[:my_projects].map{|p| Project.find(p)}
        end
        @current_user
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user && !current_user.new_record?
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      unless user_signed_in?
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message + cookies.permanent.signed[:my_projects].inspect
  end

end
