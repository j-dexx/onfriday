class ShippingOption < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper
	
	acts_as_eskimagical :recycle => true
	
	has_and_belongs_to_many :promo_codes
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  named_scope :region, lambda{|region| { :conditions => ["region = ?", region] } }
  
  validates_presence_of :name, :price, :region
  validates_format_of :price, :with => /^\d+(\.\d{1,2})?$/
  
  def active?
  	display? && !recycled?
  end
  
  def self.find_by_country(country)
    return self.active.position.region("Europe") if Shipping.europe.flatten.include?(country)
    return self.active.position.region("Rest of the World") if Shipping.rest_of_the_world.flatten.include?(country)
    return self.active.position.region("United Kingdom")
  end
  
  def summary
    if price == 0
      name  
    else
      "#{name} #{number_to_currency price, :unit => '£'}"  
    end
  end
  
  def region_name
    "#{region} #{name}"
  end
  
  def region_include?(country)
    if self.region == "Europe"
      return true if Shipping.europe.flatten.include?(country)
    elsif self.region == "United Kingdom"
      return true if Shipping.great_britain.flatten.include?(country)
    elsif self.region == "Rest of the World"
      return true if Shipping.rest_of_the_world.flatten.include?(country)    
    end
    return false
  end
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
