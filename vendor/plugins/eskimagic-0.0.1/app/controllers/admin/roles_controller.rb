class Admin::RolesController < Admin::AdminController
  def index
    @search = Role.search(params[:search])
    @roles = @search.paginate(:page => params[:page])    
  end  
  def new
    @role = Role.new
  end  
  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = "Successfully created role."
      redirect_to admin_roles_path
    else
      render :action => 'new'
    end
  end  
  def edit
    @role = Role.find(params[:id])
  end  
  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = "Successfully updated role."
      redirect_to admin_roles_path
    else
      render :action => 'edit'
    end
  end  
  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    flash[:notice] = "Successfully destroyed role."
    redirect_to admin_roles_path
  end
end