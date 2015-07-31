class ProductStory < ActiveRecord::Base
	
	acts_as_eskimagical :recycle => true
	may_contain_images :summary
	
	has_and_belongs_to_many :products, :join_table => "products_product_stories"
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  validates_presence_of :name, :summary
  
  def active?
  	display? && !recycled?
  end
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
