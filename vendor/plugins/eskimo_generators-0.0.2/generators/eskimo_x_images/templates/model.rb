class <%= class_name %>Image < ActiveRecord::Base
	
  acts_as_eskimagical
	
	belongs_to :<%= singular_name %>
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ? AND date <= ?", false, true, Date.today]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :<%= singular_name %>_id, lambda{|<%= singular_name %>_id| {:conditions => ["<%= singular_name %>_id = ?", <%= singular_name %>_id]} }
  
  has_attached_image :image, :styles => {:index => "150x150#", :show => "400"}
  has_images
  
  def active?
  	display? && !recycled?
  end
  
end
