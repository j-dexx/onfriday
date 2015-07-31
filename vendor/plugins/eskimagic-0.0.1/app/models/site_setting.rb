class SiteSetting < ActiveRecord::Base
  
  acts_as_eskimagical
  
  named_scope :like, lambda { |param| { :conditions => ['name = ?', param] } }
  named_scope :super_admin, :conditions => {:super_admin_only => true}
  named_scope :normal, :conditions => {:super_admin_only => false}
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :condtions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled?
  end
  
  def self.value(name)
    if self.like(name).first
      self.like(name).first.value
    else
      ""
    end
  end
  
end
