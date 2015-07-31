class Brand < ActiveRecord::Base
	
	acts_as_eskimagical :recycle => true
	
	has_many :products
	
	may_contain_images :story
	may_contain_documents :story
	has_attached_image :image, :styles => {:large => "260>", :small => "220>"}
	has_attached_image :image_2, :styles => {:large => "325>"}
	has_images
	Image_name = "Logo"
	Image_small_name = "Product Show Page / Brand List Page"
	Image_large_name = "Brand Show Page"
	Image_2_name = "Show Page Right Image"
	Image_2_large_name = "Brand Show Page Right Image"
  
	named_scope :position, :order => "brands.position"
  named_scope :active, :conditions => ["brands.recycled = ? AND brands.display = ? AND products.brand_id", false, true], :include => "products"
  named_scope :recycled, :conditions => ["brands.recycled = ?", true]
  named_scope :unrecycled, :conditions => ["brands.recycled = ?", false]
  
  validates_presence_of :name
  validates_attachment_presence :image
  
  def active?
  	display? && !recycled? && products.length > 0
  end
        
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
