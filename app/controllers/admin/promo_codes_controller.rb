class Admin::PromoCodesController < Admin::AdminController
  def index
    @search = PromoCode.unrecycled.search(params[:search])
    @promo_codes = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @promo_code = PromoCode.new
  end  

  def create
    @promo_code = PromoCode.new(params[:promo_code])
    if @promo_code.save
      flash[:notice] = "Successfully created promo code."
      redirect_to admin_promo_codes_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @promo_code = PromoCode.find(params[:id])
  end  

  def update
    params[:promo_code][:product_ids] ||= []
    @promo_code = PromoCode.find(params[:id])
    if @promo_code.update_attributes(params[:promo_code])
      flash[:notice] = "Successfully updated promo code."
      redirect_to admin_promo_codes_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      PromoCode.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @promo_code = PromoCode.find(params[:id])
    @promo_code.destroy
    flash[:notice] = "Successfully destroyed promo code."
    redirect_to admin_promo_codes_path
  end
  
end
