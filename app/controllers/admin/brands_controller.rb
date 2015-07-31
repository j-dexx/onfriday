class Admin::BrandsController < Admin::AdminController

  handles_images_for Brand

  def index
    @search = Brand.position.unrecycled.search(params[:search])
    @brands = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @brand = Brand.new
  end  

  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      flash[:notice] = "Successfully created brand."
      if Brand.image_changes?(params[:brand])
        redirect_to :action => "index_images", :id => @brand.id
      else
        redirect_to admin_brands_path
      end
    else
      render :action => 'new'
    end
  end  

  def edit
    @brand = Brand.find(params[:id])
  end  

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Successfully updated brand."
      if Brand.image_changes?(params[:brand])
        redirect_to :action => "index_images", :id => @brand.id
      else
        redirect_to admin_brands_path
      end
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Brand.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    flash[:notice] = "Successfully destroyed brand."
    redirect_to admin_brands_path
  end
end
