class Role < ActiveRecord::Base
  
  acts_as_eskimagical
  
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :condtions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled?
  end
  
  has_and_belongs_to_many :administrators
  has_and_belongs_to_many :features
  
end