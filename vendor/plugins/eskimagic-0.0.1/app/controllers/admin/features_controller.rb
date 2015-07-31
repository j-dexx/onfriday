class Admin::FeaturesController < Admin::AdminController
  
  def index
  	params[:type] ||= "Website Content"
    
  	if params[:type] == "Souper Features"
      @features = Feature.menu.super_admin
    elsif params[:type] == "Permissions Features"
      @features = Feature.not_menu
    else
      @features = Feature.menu.normal.location(params[:type])
    end
  end 
  
  def new
    @feature = Feature.new
  end  
  
  def create
    @feature = Feature.new(params[:feature])
    if @feature.save
      flash[:notice] = "Successfully created feature."
      redirect_to admin_features_path
    else
      render :action => 'new'
    end
  end  
  
  def edit
    @feature = Feature.find(params[:id])
  end  
  
  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      flash[:notice] = "Successfully updated feature."
      redirect_to admin_features_path
    else
      render :action => 'edit'
    end
  end  
  
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy
    flash[:notice] = "Successfully destroyed feature."
    redirect_to admin_features_path
  end
  
  def order
    params[:draggable].each_with_index do |id, index|
      Feature.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
    
end