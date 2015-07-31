class Admin::ProductImagesController < Admin::AdminController

  handles_images_for ProductImage

  def index
    if params[:product_id]
      session[:product_id] = params[:product_id]
    end
    @product = Product.find(session[:product_id])
    @search = ProductImage.unrecycled.position.product_id(@product.id).search(params[:search])
    @product_images = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @product = Product.find(session[:product_id])
    @product_image = ProductImage.new(:product_id => @product.id)
  end  

  def create
    @product_image = ProductImage.new(params[:product_image])
    if @product_image.save
      flash[:notice] = "Successfully created product image."
      redirect_to admin_product_images_path(:product_id => @product_image.product.id)
    else
      render :action => 'new'
    end
  end  

  def edit
    @product_image = ProductImage.find(params[:id])
  end  

  def update
    @product_image = ProductImage.find(params[:id])
    @product = Product.find(session[:product_id])
    if @product_image.update_attributes(params[:product_image])
      flash[:notice] = "Successfully updated product image."
      redirect_to admin_product_images_path(:product_image => @product.id)
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      ProductImage.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @product_image = ProductImage.find(params[:id])
    @product_image.destroy
    flash[:notice] = "Successfully destroyed product image."
    redirect_to admin_product_images_path
  end
end
