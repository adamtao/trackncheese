class SessionsController < ApplicationController

  def new    
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth['provider'], 
                      uid: auth['uid'].to_s).first || User.create_with_omniauth(auth)
# Reset the session after successful login, per
# 2.8 Session Fixation – Countermeasures:
# http://guides.rubyonrails.org/security.html#session-fixation-countermeasures
    reset_session
    session[:user_id] = user.id
    if cookies.permanent.signed[:my_projects]
      logger.debug "--------------------> #{user.inspect}"
      cookies.permanent.signed[:my_projects].each do |pid|
        p = Project.find(pid)
        p.user_id ||= user.id
        p.save!
      end
      cookies.permanent.signed[:my_projects] = nil
    end
    if user.email.blank?
      redirect_to edit_user_path(user), alert: "Please enter your email address."
    else
      redirect_to projects_url, notice: 'Signed in!'
    end

  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to new_session_path, alert: "Authentication error: #{params[:message].humanize}"
  end

end
