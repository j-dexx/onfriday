class <%= class_name %> < ActiveRecord::Base
	
  acts_as_eskimagical
	acts_as_authentic
	
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled?
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    <%= class_name %>Mailer.deliver_password_reset_instructions(self)  
  end  
  
end
