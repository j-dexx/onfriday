class Admin::AdministratorsController < Admin::AdminController
  
  before_filter :protect_super_admins
  
  handles_images_for Administrator
  
  def protect_super_admins
    if params[:id]
      if Administrator.find(params[:id]).super_admin?
        unless @current_administrator.super_admin?
          logger.info "#{@current_administrator.username} - unauthorized access attempt - edit super admin"
          flash[:error] = "Permission Denied - this unauthorized access attempt has been logged"
          redirect_to admin_administrators_path
        end
      end
    end
  end
  
  def index
    if @current_administrator.super_admin?
      @search = Administrator.search(params[:search])
    else
      @search = Administrator.normal.search(params[:search])
    end
    @administrators = @search.paginate(:page => params[:page])
  end
  
  def new
    @administrator = Administrator.new
  end
  
  def create
    params[:administrator][:role_ids] ||= []  
    @administrator = Administrator.new(params[:administrator])
    if @administrator.save
      flash[:notice] = "Successfully created administrator."
      redirect_to admin_administrators_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @administrator = Administrator.find(params[:id])
  end
  
  def edit_self
  	@administrator = @current_administrator
  end
  
  def update
    params[:administrator][:role_ids] ||= []  
    @administrator = Administrator.find(params[:id])
    if @administrator.update_attributes(params[:administrator])
      flash[:notice] = "Successfully updated administrator."
      redirect_to admin_administrators_path
    else
      render :action => 'edit'
    end
  end
  
  def update_self
  	@administrator = @current_administrator
  	if @administrator.can?("admin/administrators")
  		params[:administrator][:role_ids] ||= []  
  	end
  	if @administrator.update_attributes(params[:administrator])
      flash[:notice] = "Successfully your profile."
      redirect_to admin_path
    else
      render :action => 'edit_self'
    end
  end
  
  def destroy
    @administrator = Administrator.find(params[:id])
    @administrator.destroy
    flash[:notice] = "Successfully destroyed administrator."
    redirect_to admin_administrators_path
  end
end
