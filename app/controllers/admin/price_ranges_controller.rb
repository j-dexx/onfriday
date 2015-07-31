class Admin::PriceRangesController < Admin::AdminController
  def index
    @search = PriceRange.position.unrecycled.search(params[:search])
    @price_ranges = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @price_range = PriceRange.new
  end  

  def create
    @price_range = PriceRange.new(params[:price_range])
    if @price_range.save
      flash[:notice] = "Successfully created price range."
      redirect_to admin_price_ranges_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @price_range = PriceRange.find(params[:id])
  end  

  def update
    @price_range = PriceRange.find(params[:id])
    if @price_range.update_attributes(params[:price_range])
      flash[:notice] = "Successfully updated price range."
      redirect_to admin_price_ranges_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      PriceRange.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @price_range = PriceRange.find(params[:id])
    @price_range.destroy
    flash[:notice] = "Successfully destroyed price range."
    redirect_to admin_price_ranges_path
  end
end
