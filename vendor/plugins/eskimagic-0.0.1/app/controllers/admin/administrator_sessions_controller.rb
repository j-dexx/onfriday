class Admin::AdministratorSessionsController < Admin::AdminController
    
  def new
    @administrator_session = AdministratorSession.new
  end
  
  def create
    @administrator_session = AdministratorSession.new(params[:administrator_session])
    if @administrator_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to admin_path
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @administrator_session = AdministratorSession.find
    @administrator_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to admin_login_path
  end
end
