class Admin::ProductsController < Admin::AdminController
  def index
    params[:search] ||= {}
    params[:order] ||= {}
    @search = Product.unrecycled.search(params[:search])
    @products = @search
    @products = @products.sort_by{|x| x.amount_sold}.reverse if params[:search][:order] == "descend_by_amount_sold"
    @products = @products.sort_by{|x| x.amount_sold} if params[:search][:order] == "ascend_by_amount_sold"
    @products = @products.sort_by{|x| x.sales_total}.reverse if params[:search][:order] == "descend_by_sales_total"
    @products = @products.sort_by{|x| x.sales_total} if params[:search][:order] == "ascend_by_sales_total"
    @products = @products.paginate(:page => params[:page], :per_page => 200)
  end  
  
  def sort
    @search = Product.unrecycled.position.search(params[:search])
    @products = @search.paginate(:page => params[:page], :per_page => 1000)
  end  

  def new
    @product = Product.new
  end  

  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = "Successfully created product."
      redirect_to admin_products_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @product = Product.find(params[:id])
  end  

  def update
    params[:product][:associated_product_ids] ||= []
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:notice] = "Successfully updated product."
      redirect_to admin_products_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Product.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = "Successfully destroyed product."
    redirect_to admin_products_path
  end
end
