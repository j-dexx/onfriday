class PriceRange < ActiveRecord::Base

  acts_as_eskimagical :recycle => true
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  validates_format_of :start, :with => /^\d+(\.\d{1,2})?$/
  validates_format_of :end, :with => /^\d+(\.\d{1,2})?$/
  
  def active?
  	display? && !recycled?
  end
  
  def self.to_array
    ret = [["All", "0-10000"]]
    for price_range in self.active.position
      if price_range.end > 10000
        end_price = "and higher"
      else
        end_price = "to £#{"%.2f" % price_range.end}"
      end
      ret << ["£#{"%.2f" % price_range.start} #{end_price}","#{price_range.start}-#{price_range.end}"]
    end
    ret
  end
  
  
  # this will just put in ten pound chunks from 0 to the highest price
  def self.auto_to_array
    ret = [["All", nil]]
    highest_price = Product.active.sort_by{|x| x.price}.last.price
    count = 0
    while count < highest_price
      ret << ["£#{count} to £#{count+10}","#{count}-#{count+10}"]
      count += 10
    end
    ret
  end
  
  
end
