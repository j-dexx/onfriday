class BasketsController < ApplicationController

  include ActionView::Helpers::NumberHelper

  before_filter :initialize_basket
  before_filter :check_credit_is_valid, :only => [:payment, :index]

  protect_from_forgery :except => [:sagepay_success, :sagepay_failure, :paypal_reply]

  def index
  end

  def check_credit_is_valid
    # check credit hasnt become negative (should never happen but i am paranoid)
    if current_basket.credit < 0
      current_basket.update_attribute(:credit, 0)
    end
    # check the user hasnt used more credit than they have
    if current_user && current_basket.credit > current_user.credit
      current_basket.update_attribute(:credit, current_user.credit)
    end
    # check the credit isnt more than the basket total
    if current_user && current_basket.credit > current_basket.total_without_credit
      if current_basket.total_without_credit <= current_user.credit
        # if the user has enough credit to cover the basket apply it
        current_basket.update_attribute(:credit, current_basket.total_without_credit)
      else
        # else just apply what they can
        current_basket.update_attribute(:credit, current_user.credit)
      end
    end
  end

  def add
    product = Product.find(params[:product_id])
    if product.stock > 0
      same_product = @current_basket.basket_items.select{|x| x.product_id == params[:product_id].to_i}.first
      if same_product
        same_product.update_attribute(:amount, same_product.amount + 1)
        flash[:notice] = "Amount increased"
      else
        BasketItem.create(:basket_id => @current_basket.id, :product_id => params[:product_id])
        flash[:notice] = "Product added to basket"
      end
    else
      flash[:error] = "Sorry, this product is out of stock"
    end
    redirect_to basket_path
  end

  def remove_credit
    current_basket.update_attribute(:credit, 0)
    flash[:notice] = "Credit removed"
    redirect_to :action => "payment"
  end

  def add_credit
    requested_credit = params[:credit].to_f
    max = [current_basket.total_without_credit, current_user.credit].min
    if requested_credit > max
      requested_credit = max
    end
    current_basket.update_attribute(:credit, requested_credit)
    flash[:notice] = "Credit applied"
    redirect_to :action => "payment"
  end

  def increase
    basket_item = BasketItem.find(params[:basket_item_id])
    new_amount = basket_item.amount + 1
    if new_amount > basket_item.product.stock
      flash[:error] = "Sorry, we do not have enough stock to increase the amount"
    else
      basket_item.update_attribute(:amount, new_amount)
      flash[:notice] = "Amount increased"
    end
    redirect_to basket_path
  end

  def decrease
    basket_item = BasketItem.find(params[:basket_item_id])
    new_amount = basket_item.amount - 1
    if new_amount == 0
      basket_item.destroy
      flash[:notice] = "Product removed from basket"
    else
      basket_item.update_attribute(:amount, new_amount)
      flash[:notice] = "Amount decreased"
    end
    redirect_to basket_path
  end

  def remove
    basket_item = BasketItem.find(params[:basket_item_id])
    if basket_item.basket == @current_basket
      basket_item.destroy
      flash[:notice] = "Product removed from basket"
    else
      flash[:error] = "You do not have persmission to alter this Product"
    end
    redirect_to basket_path
  end

  def begin_checkout
    if @current_basket.delivery_ready?
      redirect_to :action => "delivery"
    else
      redirect_to :action => "user"
    end
  end

  def delivery
    unless @current_basket.delivery_ready?
      redirect_to :action => "user"
      return
    end
    @shipping_options = ShippingOption.find_by_country(@current_basket.delivery_country)
    @addresses = @current_basket.user.addresses
    # if for any reason the addresses can't be set give it a default value.
    @addresses ||= []
  end

  def delivery_shipping
    @shipping_options = ShippingOption.find_by_country(@current_basket.delivery_country)
  end

  def set_delivery
    if @current_basket.update_attributes(params[:basket])
      # have a look at the address and see if it is one which the user has not used before
      Address.create_from_basket_billing(@current_basket) if @current_basket.new_billing_address?(params[:basket])
      Address.create_from_basket_delivery(@current_basket) if @current_basket.new_delivery_address?(params[:basket])
      if @current_basket.shipping_option && @current_basket.delivery_country && @current_basket.shipping_option.region_include?(@current_basket.delivery_country)
        @current_basket.update_attribute(:delivery_summary, @current_basket.shipping_option.name)
        if @current_basket.non_deliverable?
          redirect_to :action => "payment"
        else
          redirect_to :action => "gift_wrap"
        end
      else
        if @current_basket.non_deliverable?
          redirect_to :action => "payment"
        else
          redirect_to :action => "delivery_shipping"
        end
      end
    else
      @shipping_options = ShippingOption.find_by_country(@current_basket.delivery_country)
      @addresses = @current_basket.user.addresses
      # if for any reason the addresses can't be set give it a default value.
      @addresses ||= []
      render :action => "delivery"
    end
  end

  def change_billing_address
    if Address.exists?(params[:address_id])
      address = Address.find(params[:address_id])
    else
      address = Address.new
    end
    render :update do |page|
      page[:basket_billing_first_names].value = address.first_names
      page[:basket_billing_surname].value = address.surname
      page[:basket_billing_address_1].value = address.address_1
      page[:basket_billing_address_2].value = address.address_2
      page[:basket_billing_city].value = address.city
      page[:basket_billing_postcode].value = address.postcode
      page[:basket_billing_country].value = address.country
      page << "fireEvent(document.getElementById('basket_billing_country'), 'change');"
    end
  end

  def change_delivery_address
    if Address.exists?(params[:address_id])
      address = Address.find(params[:address_id])
    else
      address = Address.new
    end
    render :update do |page|
      page[:basket_delivery_first_names].value = address.first_names
      page[:basket_delivery_surname].value = address.surname
      page[:basket_delivery_address_1].value = address.address_1
      page[:basket_delivery_address_2].value = address.address_2
      page[:basket_delivery_city].value = address.city
      page[:basket_delivery_postcode].value = address.postcode
      page[:basket_delivery_country].value = address.country
      page << "fireEvent(document.getElementById('basket_delivery_country'), 'change');"
    end
  end

  def set_gift_wrap
    if @current_basket.update_attributes(params[:basket])
      redirect_to :action => "payment"
    else
      render :action => "gift_wrap"
    end
  end

  def set_promotional_code
    promo_code = PromoCode.find_by_code(params[:promo_code])
    if promo_code.nil?
      flash[:error] = "Could not find a promotion with the code you entered."
    elsif promo_code.active?
      if !promo_code.minimum_amount? || (promo_code.minimum_amount? && @current_basket.products_subtotal >= promo_code.minimum_amount)
        @current_basket.update_attribute(:promo_code_id, promo_code.id)
        flash[:notice] = "Code accepted!"
      else
        flash[:error] = "Sorry, you must spend £#{"%.2f" % promo_code.minimum_amount} or more to use this promo code."
      end
    elsif promo_code.start_date > Date.today
      flash[:error] = "Sorry, this code is not active yet."
    elsif promo_code.end_date < Date.today
      flash[:error] = "Sorry, this code has expired."
    end
    render :action => "index"
  end

  def remove_promotional_code
    @current_basket.update_attribute(:promo_code_id, nil)
    flash[:notice] = "Promotional code removed."
    redirect_to :action => "index"
  end

  def user
    if current_user
      @current_basket.update_attribute(:user_id, current_user.id)
    end
    @user_session = UserSession.new
    @user = User.new
  end

  def set_user
    if current_user
      redirect_to :action => "delivery"
    else
      redirect_to :action => "user"
    end
  end

  def switch_user
    @current_basket.delivery_summary = nil
    @current_basket.billing_surname = nil
    @current_basket.billing_first_names = nil
    @current_basket.billing_address_1 = nil
    @current_basket.billing_address_2 = nil
    @current_basket.billing_city = nil
    @current_basket.billing_postcode = nil
    @current_basket.billing_country = nil
    @current_basket.delivery_first_names = nil
    @current_basket.delivery_surname = nil
    @current_basket.delivery_address_1 = nil
    @current_basket.delivery_address_2 = nil
    @current_basket.delivery_city = nil
    @current_basket.delivery_postcode = nil
    @current_basket.delivery_country = nil
    @current_basket.gift_wrap = nil
    @current_basket.gift_wrap_message = nil
    @current_basket.promo_code_id = nil
    @current_basket.shipping_option_id = nil
    @current_basket.save(false)
    session[:checkout] = true
    redirect_to logout_path
  end

  def payment
    unless @current_basket.payment_ready?
      redirect_to :action => "index"
      return
    end

    # SAGEPAY URL
    logger.info @current_basket.delivery_country

    if @current_basket.non_deliverable?
      @current_basket.delivery_first_names = @current_basket.billing_address_1
      @current_basket.delivery_surname = @current_basket.billing_surname
      @current_basket.delivery_address_1 = @current_basket.billing_address_1
      @current_basket.delivery_address_2 = @current_basket.billing_address_2
      @current_basket.delivery_city = @current_basket.billing_city
      @current_basket.delivery_postcode = @current_basket.billing_postcode
      @current_basket.delivery_country = @current_basket.billing_country
    end

    @crypt = Sagepay.crypt(
      @current_basket.id,
      number_to_currency(@current_basket.total, :unit => "").to_f,
      "Your onfriday Order (invoice ref #{@current_basket.id})",
      @current_basket.user.email,
      @current_basket.billing_first_names,
      @current_basket.billing_surname,
      @current_basket.billing_address_1,
      @current_basket.billing_address_2,
      @current_basket.billing_city,
      @current_basket.billing_postcode,
      @current_basket.billing_country,
      @current_basket.delivery_first_names,
      @current_basket.delivery_surname,
      @current_basket.delivery_address_1,
      @current_basket.delivery_address_2,
      @current_basket.delivery_city,
      @current_basket.delivery_postcode,
      @current_basket.delivery_country,
      url_for(:action => "sagepay_success"),
      url_for(:action => "sagepay_failure"),
      @current_basket.billing_state,
      @current_basket.delivery_state
    )

    logger.info @current_basket.delivery_country
    logger.info "UNENCRYPTED DATA"
    logger.info Sagepay.decrypt(@crypt).to_yaml

=begin

    # PAYPAL URL
    business = 'ali.gane@tiscali.co.uk'
    return_url = url_for(:controller => "web", :action => "index", :only_path => false)
    notify_url = url_for(:controller => "baskets", :action => "paypal_reply", :only_path => false)

  	values = {
      :business => business,
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :notify_url => notify_url,
      :currency_code => 'GBP',
      :no_shipping => 1,
      :address1 => @current_basket.billing_address_1,
      :address2 => @current_basket.billing_address_2,
      :city => @current_basket.billing_city,
      :country => @current_basket.billing_country,
      :email => @current_basket.user.email,
      :first_name => @current_basket.billing_first_names,
      :last_name => @current_basket.billing_surname,
      :zip => @current_basket.billing_postcode,
      :custom => @current_basket.id
    }

    # calculate the total discount and apply it to the cart
    values = values.merge(:discount_amount_cart => @current_basket.discount_subtotal) if @current_basket.discount_subtotal > 0

    count = 0
    @current_basket.basket_items.each_with_index do |basket_item, index|
      count = index + 1
      values.merge!({
        "amount_#{count}" => sprintf('%.2f', basket_item.subtotal),
        "item_name_#{count}" => basket_item.product_name_product_code,
        "item_number_#{count}" => basket_item.id,
        "quantity_#{count}" => 1
      })
    end

    if @current_basket.gift_wrap?
      count += 1
      values.merge!({
        "amount_#{count}" => sprintf('%.2f', @current_basket.gift_wrap_subtotal),
        "item_name_#{count}" => "Gift Wrap"
      })
    end

    if @current_basket.delivery_subtotal > 0
      count += 1
      values.merge!({
        "amount_#{count}" => sprintf('%.2f', @current_basket.delivery_subtotal),
        "item_name_#{count}" => @current_basket.delivery_summary
      })
    end

    #@paypal_url = "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query # DEMO
    @paypal_url = "https://www.paypal.com/cgi-bin/webscr?" + values.to_query # LIVE
=end

  end

  def sagepay_success
    @decrypt = Sagepay.decrypt(params["crypt"])
    if @decrypt["Status"] == "OK"
      basket = Basket.find(:first, :conditions => "id = #{@decrypt["VendorTxCode"].scan(/---(\d+)\z/).first.first.to_i}")
      if basket
        @order = basket.convert_to_order("paid (£#{@decrypt["Amount"]} via SagePay)", @decrypt)
        @current_basket = nil
        flash[:notice] = "Thank you for your order"
      else
        flash[:error] = "There was a problem with your payment, please contact us to resolve this issue"
      end
    else
      flash[:error] = "There was a problem with your payment, please contact us to resolve this issue"
    end
  end

  def paypal_reply
    if params[:payment_status].to_s == 'Completed'
      basket = Basket.find(params[:custom].to_i)
      if basket
        basket.convert_to_order("paid (£#{params["mc_gross"]} via PayPal)", params)
      end
    end
    render :nothing => true
  end

  def sagepay_failure
    results = Sagepay.decrypt(params["crypt"])
    case results["Status"]
      when "NOTAUTHED"
        @message = "You failed to enter valid card details 3 times (NOTAUTHED RESULT)"
      when "MALFORMED"
        @message = "The transaction post was poorly formatted (MALFORMED ERROR)"
      when "INVALID"
        @message = "Error in the data sent to Sagepay (INVALID ERROR)"
      when "ABORT"
        @message = "You cancelled the transaction or the transaction was inactive for too long and timed out (ABORT RESULT)"
      when "REJECTED"
        @message = "You may have failed the AVS, CV2 or 3D-Secure checks (REJECTED RESULT)"
      when "ERROR"
        @message = "There is a problem with Sagepay, site may be down for maintainance (ERROR)"
      else
        @message = "An unknown error has occurred"
    end
  end

  def credit_payment
    unless current_basket.credit_payment_valid?
      flash[:error] = "You cannot access this payment option"
      redirect_to :action => "payment"
      return
    end

    if !Order.find_by_basket_id(current_basket.id)
      logger.info "Current basket orderable? #{current_basket.orderable?}"
      logger.info "Current basket payment ready? #{current_basket.payment_ready?}"
      if current_basket.orderable? && current_basket.payment_ready?
        logger.info "Creating Order for #{current_basket.id}"
        current_basket.convert_to_order("paid (£#{current_basket.credit} via Credit)", nil)
        current_user.update_attribute(:credit, current_user.credit - current_basket.credit)
      end
      flash[:notice] = "Order Placed"
    else
      flash[:error] = "Basket already has order (##{current_basket.id})"
    end

    redirect_to :controller => "users", :action => "index"
  end

end
