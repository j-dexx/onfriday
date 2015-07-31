module <%= plural_class_name %>Helper

  def current_<%= singular_name %>_session  
    return @current_<%= singular_name %>_session if defined?(@current_<%= singular_name %>_session)  
    @current_<%= singular_name %>_session = <%= class_name %>Session.find  
  end  
    
  def current_<%= singular_name %>  
    @current_<%= singular_name %> = current_<%= singular_name %>_session && current_<%= singular_name %>_session.record  
  end  
  
  def validate_<%= singular_name %>
    unless current_<%= singular_name %>
      flash[:error] = "You must login to view this content"
      redirect_to <%= singular_name %>_login_path
      return
    end
  end
  
  def validate_no_<%= singular_name %>
    if current_<%= singular_name %>
      flash[:error] = "You must not be logged in to view this content"
      redirect_to root_url
      return
    end
  end

end
