class <%= class_name %>PasswordResetsController < ApplicationController

  include <%= plural_class_name %>Helper

  before_filter :load_<%= singular_name %>_using_perishable_token, :only => [:edit, :update]  
  before_filter :validate_no_<%= singular_name %>
    
  def edit  
  end 

  def new  
  end  
  
  def create  
    @<%= singular_name %> = <%= class_name %>.find_by_email(params[:email])  
    if @<%= singular_name %> 
      @<%= singular_name %>.deliver_password_reset_instructions!  
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +  "Please check your email."  
      redirect_to root_url  
    else  
      flash[:error] = "No <%= human_singular_name %> was found with that email address."  
      render :action => :new  
    end  
  end  
  
  def update  
    @<%= singular_name %>.password = params[:<%= singular_name %>][:password]  
    @<%= singular_name %>.password_confirmation = params[:<%= singular_name %>][:password_confirmation]  
    if @<%= singular_name %>.save  
      flash[:notice] = "Password successfully updated"  
      redirect_to <%= plural_name %>_path  
    else  
      render :action => :edit  
    end  
  end  
  
  private
    
  def load_<%= singular_name %>_using_perishable_token  
    @<%= singular_name %> = <%= class_name %>.find_using_perishable_token(params[:id])  
    unless @<%= singular_name %>
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."  
      redirect_to root_url  
    end
  end  
  
end
