class OrderItem < ActiveRecord::Base
	
	acts_as_eskimagical
	
	belongs_to :order
	belongs_to :product
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  
  after_create :prepare_order_item
  
  def prepare_order_item
    # NORMAL PRODUCT
    if order_item_type == 0
      product.update_attribute(:stock, product.stock - amount)
    end
    # VOUCHER
    if voucher?
      self.code = OrderItem.unique_code
      self.generate_voucher_pdf
      Mailer.deliver_voucher_to_customer(self)
      if delivery_email?
        Mailer.deliver_voucher_to_recipient(self)
      end
    end
    # DONATION
    if donation?
      secret = delivery_type == "Secret" ? true : false
      Donation.create!(:donation_page_id => target_id, 
                   :order_item_id => self.id,
                   :message => message,
                   :value => value,
                   :user_id => order.user.id,
                   :secret => secret)
    end
    self.save
  end
  
  def self.unique_code(length=10)
    o =  [('a'..'z'),('A'..'Z'),(0..10)].map{|i| i.to_a}.flatten;  
    random_string = (0..length-1).map{ o[rand(o.length)]  }.join;
    same_code = OrderItem.find_by_code(random_string)
    while same_code
      random_string = (0..10).map{ o[rand(o.length)]  }.join;
      same_code = OrderItem.find_by_code(random_string)
    end
    return random_string
  end
  
  def active?
  	display? && !recycled?
  end
  
  def restore_stock
    product.update_attribute(:stock, product.stock + amount) if Product.exists?(self.product_id)
  end
  
  def name_code
    if Product.exists?(self.product_id)
     "#{product.name} (#{product.product_code})"
    else
      product_name
    end
  end
  
  def generate_voucher_pdf
    folder = File.join(RAILS_ROOT, 'private', 'vouchers', self.id.to_s)
    FileUtils.mkpath(folder)
    file = File.join(folder, 'voucher.pdf')
    pdf = Prawn::Document.new
    Prawn::Document.generate(file) do |pdf| 
      # Backgroun Image
      image_path = File.join(RAILS_ROOT, "public", "images", "gift_voucher_pdf.jpg")
      pdf.image image_path, :at => [0, pdf.bounds.height], :width => pdf.bounds.width, :height => pdf.bounds.height
      georgia = File.join(RAILS_ROOT, "public", "fonts", "georgia.ttf")
      georgiab = File.join(RAILS_ROOT, "public", "fonts", "georgiab.ttf")
      georgiaz = File.join(RAILS_ROOT, "public", "fonts", "georgiaz.ttf")    
      pdf.font georgia
            
      # Value
      pdf.bounding_box([95, 390], :width => 200, :height => 200) do
        pdf.font georgiaz
        pdf.text "For:", :align => :center, :size => 20, :spacing => 3
        pdf.font georgiab
      	pdf.text "£#{"%.2f" % value}", :align => :center, :size => 30, :spacing => 3
      	pdf.font georgia
    	end
    	
    	# Details
      pdf.bounding_box([300, 420], :width => 140, :height => 290) do
        pdf.font georgiab
        pdf.text "To:", :align => :left, :size => 10, :spacing => 3
        pdf.font georgia
      	pdf.text name, :align => :left, :size => 10, :spacing => 3
      	pdf.text " "
      	pdf.font georgiab
        pdf.text "From:", :align => :left, :size => 10, :spacing => 3
        pdf.font georgia
      	pdf.text order.user.full_name, :align => :left, :size => 10, :spacing => 3
      	pdf.text " "
      	pdf.text message, :align => :left, :size => 8, :spacing => 3
    	end
      
      # Code
      pdf.bounding_box([30, 250], :width => 400, :height => 100) do
      	pdf.font georgiaz
        pdf.text "VOUCHER CODE: #{code}", :align => :center, :size => 12, :spacing => 3
    	end
    	
    end
  end
  
  def voucher_pdf_path
    File.join(RAILS_ROOT, 'private', 'vouchers', self.id.to_s, 'voucher.pdf')
  end
  
  def item_type
    return order_item_type
  end
  
  def voucher?
    order_item_type == 1 ? true : false
  end
  
  def donation?
    order_item_type == 2 ? true : false
  end
  
  def non_physical?
    voucher? || donation?
  end
  
  def delivery_email?
    delivery_type == "Email"
  end
  
  def delivery_print?
    delivery_type == "Print"
  end
  
  def used?
    used_user?
  end
  
  def use(user)
    self.update_attribute(:used_user, user.id)
    user.update_attribute(:credit, user.credit + self.value)
  end
  
  def users_name
    if User.exists?(used_user)
      User.find(used_user).full_name
    else
      ""
    end
  end
  
  def donation_page
    if target_id.blank? || !DonationPage.exists?(target_id)
      return nil
    else
      DonationPage.find(target_id)
    end
  end
  
end
