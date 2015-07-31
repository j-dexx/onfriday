class ProductImage < ActiveRecord::Base
	
	acts_as_eskimagical :recycle => true
	
	belongs_to :product
	
	has_attached_image :image, :styles => {:tiny => "107x107#", :small => "216x216#", :large => "480x480#", :huge => "700x500"}
	Image_tiny_name = "Thumbnail"
	Image_small_name = "Product List"
	Image_large_name = "Show Page Large"
	Image_huge_name = "Show Page Full Screen"
	has_images
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :product_id, lambda{|product_id| {:conditions => ["product_id = ?", product_id]} }
  
  def active?
  	display? && !recycled?
  end
  
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
end
