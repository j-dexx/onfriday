class Product < ActiveRecord::Base
  
  has_friendly_id :name, :use_slug => true
	
	acts_as_eskimagical :recycle => true
	acts_as_taggable_on :colours, :materials, :types
	may_contain_images :description
	
	has_many :product_images
	has_and_belongs_to_many :associated_products, :class_name => "Product", :join_table => "product_associations", :foreign_key => "first_product_id", :association_foreign_key => "second_product_id"
	belongs_to :brand
	has_and_belongs_to_many :product_stories, :join_table => "products_product_stories"
	has_and_belongs_to_many :promo_codes

	named_scope :position, :order => "products.position"
  named_scope :active, :conditions => ["products.recycled = ? AND products.display = ? AND brands.display = ?", false, true, true], :include => "brand"
  named_scope :recycled, :conditions => ["products.recycled = ?", true]
  named_scope :unrecycled, :conditions => ["products.recycled = ?", false]
  named_scope :arrange, :order => "name"
  
  named_scope :ascend_by_amount_sold, :conditions => true
  named_scope :descend_by_amount_sold, :conditions => true
  named_scope :ascend_by_sales_total, :conditions => true
  named_scope :descend_by_sales_total, :conditions => true
  
  named_scope :brand, lambda { |b| { :conditions => ["brands.name = ?", b], :include => "brand" } }
  named_scope :upcycled, :conditions => "upcycled = true"
  named_scope :fair_trade, :conditions => "fair_trade = true"
  named_scope :men, :conditions => ["men = ?", true]
  named_scope :women, :conditions => ["women = ?", true]
  named_scope :unisex, lambda {|gender| { :conditions => ["women = ? and men = ?", true, true] } }
  scope_procedure :taggable_with_colours, lambda { |tags| tagged_with(tags, :on => :colours) }
  scope_procedure :taggable_with_materials, lambda { |tags| tagged_with(tags, :on => :materials) }
  scope_procedure :taggable_with_types, lambda { |tags| tagged_with(tags, :on => :types) }
  scope_procedure :price_range, lambda { |range| price_greater_than(range.split('-').first).price_less_than(range.split('-').last) }
  
  validates_presence_of :name, :summary, :price, :stock
	validates_format_of :price, :with => /^\d+(\.\d{1,2})?$/
	validates_format_of :sale_price, :with => /^\d+(\.\d{1,2})?$/, :if => Proc.new{|x| x.sale_price?}
	validates_numericality_of :stock, :only_integer => true, :greater_than_or_equal_to => 0
	
	before_save :update_sale
	
	def update_sale
	  if sale_price?
	    self.sale = true
	  else
	    self.sale = false
	  end
	  return true
	end
	
  
  def active?
  	display? && !recycled? && brand.display?
  end
  
  def brand_name
    "#{brand.name} #{name}"
  end
  
  def brand_name_code
    "#{brand.name} #{name} (#{product_code})"
  end
  
  def smart_stock_message
    if stock_message?
      return stock_message
    else
      SiteSetting.like("Stock Message Default").first.value
    end
  end
  
  def self.gender_options
    ["Unisex", "Men", "Women"]
  end
  
  def amount_sold
    total = 0
    OrderItem.active.product_id_equals(self.id).each{|x| total += x.amount}
    return total
  end
  
  def sales_total
    total = 0
    OrderItem.active.product_id_equals(self.id).each{|x| total += x.subtotal}
    return total    
  end
  
  
end
