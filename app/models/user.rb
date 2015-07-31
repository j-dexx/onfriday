class User < ActiveRecord::Base

  attr_accessor :newsletter
  
  after_create :check_newsletter
	
	acts_as_eskimagical
	acts_as_authentic
	
	has_many :orders
	has_many :addresses
	has_many :donation_pages
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :arrange, :order => "email"
  
  validates_presence_of :first_names, :surname
  
  def check_newsletter
    if newsletter == "1"
      NewsletterSubscriber.create!(:email => self.email)
    end
  end
  
  def active?
  	display? && !recycled?
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Mailer.deliver_password_reset_instructions(self)  
  end    
  
  def full_name
    "#{first_names} #{surname}"
  end
  
end
