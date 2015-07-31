class Admin::ShippingOptionsController < Admin::AdminController
  def index
    @search = ShippingOption.position.unrecycled.search(params[:search])
    @shipping_options = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @shipping_option = ShippingOption.new
  end  

  def create
    @shipping_option = ShippingOption.new(params[:shipping_option])
    if @shipping_option.save
      flash[:notice] = "Successfully created shipping option."
      redirect_to admin_shipping_options_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @shipping_option = ShippingOption.find(params[:id])
  end  

  def update
    @shipping_option = ShippingOption.find(params[:id])
    if @shipping_option.update_attributes(params[:shipping_option])
      flash[:notice] = "Successfully updated shipping option."
      redirect_to admin_shipping_options_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      ShippingOption.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @shipping_option = ShippingOption.find(params[:id])
    @shipping_option.destroy
    flash[:notice] = "Successfully destroyed shipping option."
    redirect_to admin_shipping_options_path
  end
end
