class BasketItem < ActiveRecord::Base

  belongs_to :basket
  belongs_to :product
  
  # COUPON VALIDATIONS
  validates_presence_of :name, :value, :delivery_type, :if => Proc.new{|x| x.basket_item_type == 1}
  validates_numericality_of :value, :greater_than => 0, :if => Proc.new{|x| x.basket_item_type == 1}
  validates_length_of :message, :maximum => 380, :if => Proc.new{|x| x.basket_item_type == 1}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => Proc.new{|x| x.email?}
  validates_presence_of :email, :if => Proc.new{|x| x.delivery_type == "Email"}
  # DONATION VALIDATIONS
  validates_presence_of :value, :target_id, :if => Proc.new{|x| x.basket_item_type == 2}
  validates_numericality_of :value, :greater_than => 0, :if => Proc.new{|x| x.basket_item_type == 2}
  
  def subtotal
    ret = 0
    if basket_item_type == 1 || basket_item_type == 2
      # coupon or donation
      ret += value
    elsif product.sale
      ret += product.sale_price * amount
    else
      ret += product.price * amount
    end
    ret 
  end
  
  def convert_to_order_item(order)
    order_item = OrderItem.create(
      :order_id => order.id,
      :product_id => product_id,
      :amount => amount,
      :subtotal => subtotal,
      :order_item_type => basket_item_type,
      :delivery_type => delivery_type,
      :name => name,
      :email => email,
      :message => message,
      :value => value,
      :product_name => product_name,
      :target_id => target_id
    )
  end
  
  def orderable?
    if voucher?
      true
    elsif donation?
      donation_page ? true : false
    else
      amount > product.stock ? false : true
    end
  end
  
  def product_name_product_code
    if voucher?
      "Voucher (#{name})"
    elsif donation?
      "Donation (#{donation_page.name})"
    else
      "#{self.product.name} (#{self.product.product_code})"  
    end
  end
  
  def product_name
    if self.product
      self.product.name 
    elsif voucher?
      "Voucher - #{name}"
    elsif donation?
      "Donation - #{donation_page.name}"
    end
  end
  
  def self.delivery_types
    ["Email", "Print"] 
  end
  
  def voucher_summary
    ret = ""
    ret += "Gift Voucher"
    ret += "<br />"    
    ret += "To: #{name}"
    ret += "(#{email})" if email?
    ret += "<br />"
    ret += "Delivery Type: #{delivery_type}"
    return ret  
  end
  
  def donation_summary
    "Gift Donation (#{donation_page.name})"
  end
  
  def item_type
    return basket_item_type
  end
  
  def code
    return "Not Yet Generated"
  end
  
  def voucher?
    basket_item_type == 1 ? true : false
  end
  
  def donation?
    basket_item_type == 2 ? true : false
  end
  
  def non_physical?
    voucher? || donation? 
  end
  
  def donation_page
    if target_id.blank? || !DonationPage.exists?(target_id)
      return nil
    else
      DonationPage.find(target_id)
    end
  end
      
end
