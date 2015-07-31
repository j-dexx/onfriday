class Admin::UsersController < Admin::AdminController
  def index
    @search = User.unrecycled.search(params[:search])
    @users = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @user = User.new
  end  

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @user = User.find(params[:id])
  end  

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to admin_users_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      User.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to admin_users_path
  end
end