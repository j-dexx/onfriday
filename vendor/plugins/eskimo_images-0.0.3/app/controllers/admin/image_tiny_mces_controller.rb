class Admin::ImageTinyMcesController < Admin::AdminController

  layout "admin_popup"

  def index
    @search = Image.newest.search(params[:search])
    @images = @search.paginate(:page => params[:page])
  end
  
  def show
    @image = Image.find(params[:id])
  end
  
  def insert
    @image = Image.find(params[:id])
  end
  
  def new
    @image = Image.new
  end  

  def create
    @image = Image.new(params[:image])
    if @image.save
      flash[:notice] = "Successfully created image."
      redirect_to admin_image_tiny_mces_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @image = Image.find(params[:id])
  end  

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:notice] = "Successfully updated image."
      redirect_to admin_image_tiny_mces_path
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:notice] = "Successfully destroyed image."
    redirect_to admin_image_tiny_mces_path
  end
  
  def execute_frame
    require 'RMagick'
    @image = Image.find(params[:id])
    image = @image.image
    scalar = Image.scalar(image)
    new = !params[:new].blank?
    if @image.crop(
      params[:x1].to_f/scalar,
      params[:y1].to_f/scalar,
      params[:width].to_f/scalar,
      params[:height].to_f/scalar,
      new
      )
      if new
        flash[:notice] = "New stored image created"
      else
        flash[:notice] = "Stored image altered"
      end
    else
      flash[:error] = "There was a problem framing the image"
    end
    redirect_to admin_image_tiny_mces_path
  end

end
