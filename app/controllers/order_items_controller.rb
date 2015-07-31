class OrderItemsController < ApplicationController

  def index
    @search  = OrderItem.active
    @order_items = @search.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @order_item = OrderItem.find(params[:id])
  end
  
  def voucher
    @order_item = OrderItem.find(params[:id])
    unless params[:code] == @order_item.code
      flash[:error] = "You do not have permission to view this voucher."
      redirect_to users_path
      return
    end
  end
  
  def resend_voucher_email
    @order_item = OrderItem.find(params[:id])
    Mailer.deliver_voucher_to_recipient(@order_item)
    flash[:notice] = "Voucher Email Resent"
    redirect_to voucher_order_item_path(@order_item, :code => @order_item.code)
  end
  
  def download_voucher_pdf
    @order_item = OrderItem.find(params[:id])
    unless params[:code] == @order_item.code
      flash[:error] = "You do not have permission to view this voucher."
      redirect_to users_path
      return
    end
    send_file @order_item.voucher_pdf_path
  end
  
end
