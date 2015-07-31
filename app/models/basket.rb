class Basket < ActiveRecord::Base
  
  has_many :basket_items, :dependent => :destroy
  belongs_to :promo_code
  belongs_to :user
  belongs_to :shipping_option
  
  named_scope :basket_type, lambda {|x| {} }
  named_scope :ascend_by_ready, lambda {|x| {} }
  named_scope :descend_by_ready, lambda {|x| {} }  
  named_scope :ascend_by_basket_items_length, lambda {|x| {} }
  named_scope :descend_by_basket_items_length, lambda {|x| {} }
   
  validates_presence_of :delivery_first_names, :delivery_surname, 
    :delivery_address_1, :delivery_city, :delivery_postcode, 
    :delivery_country, :on => :update, :if => Proc.new{|x| !x.non_deliverable? }
    
  validates_presence_of :billing_first_names, :billing_surname, 
    :billing_address_1, :billing_city, :billing_postcode, 
    :billing_country, :on => :update
    
  def contents
    ret = ""
    ret += basket_items.length.to_s
    if basket_items.length > 0
      ret += " ("
      summary = basket_items.collect{|x| x.product_name}.to_sentence
      ret += summary.length > 50 ? "#{summary[0..50]}..." : summary
      ret += ")"
    end
    ret
  end
    
  def products_subtotal
    ret = 0
    for basket_item in basket_items
      ret += basket_item.subtotal
    end
    ret 
  end
  
  def discountable_products_subtotal
    ret = 0
    for basket_item in basket_items
      ret += basket_item.subtotal unless basket_item.non_physical?
    end
    ret
  end
  
  def discountable_basket_items
    basket_items.reject{|x| x.non_physical?}
  end
  
  def delivery_subtotal
    ret = 0
    ret += shipping_option.price if shipping_option
    if non_deliverable?
      ret = 0
    end  
    ret
  end
  
  def self.safe_gift_wrap_price
    price = SiteSetting.like("Gift Wrap Price").first
    if price && price.value?
      return price.value.to_f
    else
      4.95
    end
  end
  
  def gift_wrap_subtotal
    ret = 0
    ret += Basket.safe_gift_wrap_price if gift_wrap?
    if non_deliverable?
      ret = 0
    end
    ret
  end
  
  def discount_subtotal
    ret = 0
    if (promo_code && promo_code.minimum_amount.blank?) || (promo_code && promo_code.minimum_amount && self.discountable_products_subtotal >= promo_code.minimum_amount)
      if promo_code.promo_code_type == "percentage_off_basket"
        ret += ( discountable_products_subtotal * (promo_code.percentage_off.to_f / 100.to_f).to_f )
      elsif promo_code.promo_code_type == "percentage_off_products"
        for basket_item in discountable_basket_items
          if promo_code.products.include?(basket_item.product)        
            ret += (basket_item.subtotal * (promo_code.percentage_off.to_f / 100.to_f).to_f)
          end
        end
      elsif promo_code.promo_code_type == "amount_off_basket"
        ret += promo_code.amount_off
      elsif promo_code.promo_code_type == "amount_off_products"
        for basket_item in discountable_basket_items
          if promo_code.products.include?(basket_item.product)        
            ret += promo_code.amount_off
          end
        end
      elsif promo_code.promo_code_type == "free_shipping"
        if promo_code.shipping_options.include?(shipping_option)
          ret += shipping_option.price        
        end
      end
    end
    # discount cannot be applied to just voucher orders.
    if non_deliverable?
      ret = 0
    end
    ret
  end
  
  def total
    ret = 0
    ret += total_without_credit
    ret -= credit if credit
    ret
  end
  
  def total_without_credit
    ret = 0
    ret += products_subtotal
    ret += delivery_subtotal if !delivery_subtotal.blank?
    ret += gift_wrap_subtotal
    ret -= discount_subtotal
    ret
  end
  
  def new_billing_address?(params)
    Address.user_id_equals(self.user.id).first_names_like(params[:billing_first_names]).surname_like(params[:billing_surname]).address_1_like(params[:billing_address_1]).address_2_like(params[:billing_address_2]).city_like(params[:billing_city]).postcode_like(params[:billing_postcode]).country_like(params[:billing_country]).length > 0 ? false : true
  end
  
  def new_delivery_address?(params)
    Address.user_id_equals(self.user.id).first_names_like(params[:delivery_first_names]).surname_like(params[:delivery_surname]).address_1_like(params[:delivery_address_1]).address_2_like(params[:delivery_address_2]).city_like(params[:delivery_city]).postcode_like(params[:delivery_postcode]).country_like(params[:delivery_country]).length > 0 ? false : true
  end
  
  def empty?
    basket_items.length > 0 ? false : true
  end
  
  def orderable?
    for basket_item in basket_items
      return false if !basket_item.orderable?
    end
    return true
  end
  
  def user_ready?
    return false if empty?
    true
  end
  
  def user_done?
    return false if empty?
    return false if user == nil
    true
  end
  
  def delivery_ready?
    user_done?
  end
  
  def delivery_done?
    return false if !user_done?
    unless self.non_deliverable?
      return false if !self.delivery_first_names?
      return false if !self.delivery_surname?
      return false if !self.delivery_address_1?
      return false if !self.delivery_city?
      return false if !self.delivery_postcode?
      return false if !self.delivery_country?
      return false if !self.delivery_summary?
      return false if self.delivery_subtotal.nil?
    end
    return false if !self.billing_first_names?
    return false if !self.billing_surname?
    return false if !self.billing_address_1?
    return false if !self.billing_city?
    return false if !self.billing_postcode?
    return false if !self.billing_country?
    true
  end
  
  def gift_ready?
    delivery_done?
  end
  
  def gift_done?
    return false if !delivery_done?
    return false if gift_wrap.nil? && !non_deliverable?
    true
  end
  
  def payment_ready?
    gift_done?
  end
    
  def convert_to_order(status, gateway_reply, skip_email=false)
    order = Order.new(
      :basket_id => id,
      :user_id => self.user_id,
      :user_email => self.user.email,
      :delivery_subtotal => self.delivery_subtotal,
      :discount_subtotal => self.discount_subtotal,
      :products_subtotal => self.products_subtotal,
      :total => self.total,
      :delivery_summary => self.delivery_summary,
      :delivery_first_names => self.delivery_first_names,
      :delivery_surname => self.delivery_surname,
      :delivery_address_1 => self.delivery_address_1,
      :delivery_address_2 => self.delivery_address_2,
      :delivery_city => self.delivery_city,
      :delivery_postcode => self.delivery_postcode,
      :delivery_country => self.delivery_country,
      :billing_first_names => self.billing_first_names,
      :billing_surname => self.billing_surname,
      :billing_address_1 => self.billing_address_1,
      :billing_address_2 => self.billing_address_2,
      :billing_city => self.billing_city,
      :billing_postcode => self.billing_postcode,
      :billing_country => self.billing_country,
      :gift_wrap => self.gift_wrap,
      :gift_wrap_subtotal => self.gift_wrap_subtotal,
      :gift_wrap_message => self.gift_wrap_message,
      :status => status,
      :gateway_reply => gateway_reply,
      :credit => credit
    )
    
    logger.info "Shall I Save My New Order For Basket #{id}"
    
    unless Order.find_by_basket_id(id) 
    
      logger.info "Hell Yeah!"
      
      order.save
  
      # check that there are no problems with the order (items gone out of stock
      # while the parson was paying - etc) and email the admin if this is the case
      if !self.orderable?
        bad_items = []
        for basket_item in basket_items 
          bad_items << basket_item if !basket_item.orderable?
        end
        unless skip_email
          Mailer.deliver_order_problem_to_admin(order, bad_items)
        end
      end

      for basket_item in basket_items
        basket_item.convert_to_order_item(order)
      end

      unless skip_email    
        Mailer.deliver_order_invoice_to_admin(order)
        Mailer.deliver_order_invoice_to_customer(order)
      end
      
      self.destroy
      return order
    end
  end
  
  def self.tidy
    # destroy all 30 day old baskets
    Basket.find(:all, :conditions => ["created_at < ? AND keep = false", (Date.today-30)]) do |basket|  
      basket.destroy
    end
    # destroy all 7 day old baskets unless they are in the ready for payment mode
    Basket.find(:all, :conditions => ["created_at < ? AND keep = false", (Date.today-7)]) do |basket|
      basket.destroy unless basket.payment_ready?
    end
  end
    
  def non_deliverable?
    for basket_item in basket_items
      return false if !basket_item.non_physical?
    end
    return true
  end
  
  def credit_payment_valid?
    credit >= total_without_credit
  end
  
end
