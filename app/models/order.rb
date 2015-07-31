class Order < ActiveRecord::Base
	
	acts_as_eskimagical
	
	serialize :gateway_reply
	
	has_many :order_items, :dependent => :destroy
	belongs_to :user
	
  validates_uniqueness_of :basket_id
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  named_scope :type, lambda{|type| { :conditions => ["type LIKE %?%", type] } }
  named_scope :created_in, lambda{|date| { :conditions => ["year(created_at) = ? AND month(created_at) = ?", date.split('-').first, date.split('-').last] } }
  
  before_create :generate_online_invoice_number
  
  def active?
  	display? && !recycled?
  end
  
  def generate_online_invoice_number
    previous_invoice_number = Order.all.collect{|x| x.online_invoice_number.gsub(/\D/, '').to_i}.max
    if previous_invoice_number
      invoice_number = previous_invoice_number + 1
    else
      invoice_number = 10001 
    end
    self.online_invoice_number = "I#{invoice_number}"
  end
  
  def restore_stock
    for order_item in order_items
      order_item.restore_stock
    end
  end
  
  def non_deliverable?
    for order_item in order_items
      return false if !order_item.non_physical?
    end
    return true
  end

end
