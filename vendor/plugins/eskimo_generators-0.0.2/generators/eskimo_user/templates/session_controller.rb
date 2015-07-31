class <%= class_name %>SessionsController < ApplicationController

  def new
    @<%= singular_name %>_session = <%= class_name %>Session.new
  end
  
  def create
    @<%= singular_name %>_session = <%= class_name %>Session.new(params[:<%= singular_name %>_session])
    if @<%= singular_name %>_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to <%= plural_name %>_path  
    else
      render :action => "new"
    end
  end
    
  def destroy  
    @<%= singular_name %>_session = <%= class_name %>Session.find  
    @<%= singular_name %>_session.destroy
    flash[:notice] = "Successfully logged out."  
    redirect_to root_path  
  end  

end
