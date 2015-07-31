class PromoCode < ActiveRecord::Base
  
  has_and_belongs_to_many :products
  has_and_belongs_to_many :shipping_options
  has_many :baskets
	
	acts_as_eskimagical :recycle => true
	
	validates_presence_of :name, :code, :start_date
	validates_format_of :amount_off, :with => /^\d+(\.\d{1,2})?$/, :if => Proc.new{|x| x.amount_off?}
	validates_numericality_of :percentage_off, :only_integer => true, :greater_than => 0, :less_than => 100, :if => Proc.new{|x| x.percentage_off?}
	validates_format_of :minimum_amount, :with => /^\d+(\.\d{1,2})?$/, :if => Proc.new{|x| x.minimum_amount?}
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ? AND start_date <= ? AND (end_date IS NULL OR end_date > ?)", false, true, Date.today, Date.today]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled? && start_date <= Date.today && (end_date.nil? || end_date > Date.today)
  end
  
  def self.promo_code_types
    [
    ["Percentage off entire basket","percentage_off_basket"],
    ["Percentage off specific product(s)","percentage_off_products"],
    ["Fixed amount off entire basket","amount_off_basket"],
    ["Fixed amount off specific product(s)","amount_off_products"],
    ["Free shipping","free_shipping"]
    ]  
  end
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
