class Donation < ActiveRecord::Base
	
	acts_as_eskimagical
	
	validates_presence_of :donation_page_id, :value
	validates_numericality_of :value, :greater_than => 0
	
	belongs_to :donation_page
	belongs_to :user
	belongs_to :order_item
	
	after_create :send_emails
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled?
  end
  
  def send_emails
    Mailer.deliver_new_donation(self)
  end
  
  def donor_name
    if user
      user.full_name
    else
      "onfriday"
    end
  end
  
end
