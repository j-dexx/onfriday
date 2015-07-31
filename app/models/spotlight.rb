class Spotlight < ActiveRecord::Base

  acts_as_eskimagical

  has_attached_image :image, :styles => {:large => "325>"}
  has_images
  
  belongs_to :brand
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :highlighted, :conditions => ["highlight = ?", true]
  
  def active?
  	display? && !recycled?
  end
    
  def name
    designer
  end
  
end
