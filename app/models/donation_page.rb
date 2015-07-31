class DonationPage < ActiveRecord::Base

  attr_accessor :terms_and_conditions
	
	acts_as_eskimagical
	
	belongs_to :user
	belongs_to :product
	has_many :donations
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :inactive, :conditions => ["recycled = ? AND display = ?", false, false]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :arrange, :order => "name"
  
  validates_presence_of :product_id, :user_id, :name
  validates_acceptance_of :terms_and_conditions, :only => :create
  
  def active?
  	display? && !recycled?
  end
  
  def inactive?
    !display? && !recycled? 
  end
  
  def goal
    product.price      
  end
  
  def total
    ret = 0
    for donation in donations
      ret += donation.value
    end   
    return ret
  end  
  
  def goal_percentage
    ((total.to_f / goal.to_f) * 100.00).to_i
  end
end
