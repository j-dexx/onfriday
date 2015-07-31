module UserSessionsHelper

  def require_no_user
    if current_user
      redirect_to root_url
      flash[:error] = "You are already logged in as a user."
      return
    end
  end
  
  def require_user
    unless current_user
      redirect_to root_url
      flash[:error] = "You must be logged in to view this content."
      return
    end
  end
  
  def validate_user
    unless current_user
      flash[:error] = "You must login to view this content"
      redirect_to new_user_session_path
      return
    end
  end

end
