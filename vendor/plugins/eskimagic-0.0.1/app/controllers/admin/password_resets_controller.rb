class Admin::PasswordResetsController < ApplicationController

  before_filter :require_no_administrator
  before_filter :load_administrator_using_perishable_token, :only => [ :edit, :update ]
  
  layout "admin"
  
  def require_no_administrator
    if @current_administrator
      flash[:notice] = "You must be logged out to access this page"
      redirect_to admin_path
      return false
    end
  end
  
  def new
  end

  def create
    @administrator = Administrator.find_by_email(params[:email])
    if @administrator
      @administrator.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you"
      redirect_to admin_login_path
    else
      flash[:error] = "No administrator was found with email address #{params[:email]}"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @administrator.password = params[:password]
		@administrator.password_confirmation = params[:password_confirmation]  
    if @administrator.save
      flash[:notice] = "Your password was successfully updated"
      redirect_to admin_path
    else
    	flash[:error] = "There was a problem updating your password, please try again"
      render :action => :edit
    end
  end


  private

  def load_administrator_using_perishable_token
    @administrator = Administrator.find_using_perishable_token(params[:id])
    unless @administrator
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to admin_login_path
    end
  end

	
end
