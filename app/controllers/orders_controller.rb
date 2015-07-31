class OrdersController < ApplicationController
  def index
    @search  = Order.active
    @orders = @search.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @order = Order.find(params[:id])
  end
end