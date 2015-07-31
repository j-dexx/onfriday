  class Address < ActiveRecord::Base
  
  belongs_to :user
	
	acts_as_eskimagical
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  def active?
  	display? && !recycled?
  end
  
  def select_name
    "#{first_names} #{surname}, #{address_1}"  
  end
  
  def self.create_from_basket_billing(basket)
    Address.create!(
      :user_id => basket.user.id,
      :first_names => basket.billing_first_names,
      :surname => basket.billing_surname,
      :address_1 => basket.billing_address_1,
      :address_2 => basket.billing_address_2,
      :city => basket.billing_city,
      :postcode => basket.billing_postcode,
      :country => basket.billing_country,
      :state => basket.billing_state
    )
  end
  
  def self.create_from_basket_delivery(basket)
    Address.create!(
      :user_id => basket.user.id,
      :first_names => basket.delivery_first_names,
      :surname => basket.delivery_surname,
      :address_1 => basket.delivery_address_1,
      :address_2 => basket.delivery_address_2,
      :city => basket.delivery_city,
      :postcode => basket.delivery_postcode,
      :country => basket.delivery_country,
      :state => basket.delivery_state
    )
  end
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
