class Mailer < ActionMailer::Base
	
	add_template_helper ApplicationHelper
	
	layout "mail"
	
	def password_reset_instructions(user)  
    @subject                        = "Password Reset Instructions"  
    @from                           = SiteSetting.like("Email").first.value  
    @recipients                     = user.email  
    @body[:edit_password_reset_url] = edit_password_reset_url(user.perishable_token)  
    content_type "text/html"  
  end  

	def contact_us(name, email, tel, enquiry)
    @subject           = "Contact Us Form Completed"
    @from              = email
    @recipients        = SiteSetting.like("Email").first.value
    @body[:enquiry]    = enquiry
    @body[:name]       = name
    @body[:email]      = email
    @body[:tel]        = tel
    content_type "text/html"  
  end
  
  def order_problem_to_admin(order, bad_items)
    @subject           = "There was a problem with a customer order (#{order.online_invoice_number})"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = SiteSetting.like("Order Email").first.value
    @body[:order]      = order
    @body[:bad_items]  = bad_items
    content_type "text/html"
  end
  
  def order_invoice_to_admin(order)
    @subject           = "New onfriday Order (#{order.online_invoice_number})"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = SiteSetting.like("Order Email").first.value
    @body[:order]      = order
    content_type "text/html"
  end
  
  def order_invoice_to_customer(order)
    @subject           = "Your onfriday Order (#{order.online_invoice_number})"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = order.user.email
    @body[:order]      = order
    content_type "text/html"
  end
  
  def order_cancelled_to_customer(order)
    @subject           = "Your onfriday Order (#{order.online_invoice_number}) has been Cancelled"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = order.user.email
    @body[:order]      = order
    content_type "text/html"
  end
  
  def order_shipped_to_customer(order)
    @subject           = "Your onfriday Order (#{order.online_invoice_number}) has been Shipped"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = order.user.email
    @body[:order]      = order
    content_type "text/html"
  end
  
  def new_newsletter_subscriber(newsletter_subscriber)
    @subject           = "onfriday Newsletter Subscription"
    @from              = SiteSetting.like("Email").first.value
    @recipients        = newsletter_subscriber.email
    content_type "text/html"
  end
  
  def new_donation(donation)
    @subject           = "You've got a New onfriday Donation"
    @from              = SiteSetting.like("Email").first.value
    @recipients        = donation.donation_page.user.email
    @body[:donation]   = donation
    content_type "text/html"
  end
  
  def voucher_to_customer(order_item)
    @subject           = "Your onfriday Voucher Order"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = order_item.order.user.email
    part(:content_type => "text/html", :body => render_message("voucher_to_customer", :order_item => order_item, :order => order_item.order))
    if order_item.delivery_print?
      attachment(:content_type => "application/mixed", :body => File.read(order_item.voucher_pdf_path), :filename => "voucher.pdf")
    end
  end
  
  def voucher_to_recipient(order_item)
    @subject           = "You have been sent an onfriday gift voucher"
    @from              = SiteSetting.like("Order Email").first.value
    @recipients        = order_item.email
    part(:content_type => "text/html", :body => render_message("voucher_to_recipient", :order_item => order_item, :order => order_item.order))
  end
  
  def donation(recipients, subject, content, donation_page)
    @subject              = subject
    @from                 = SiteSetting.like("Email").first.value
    @recipients           = recipients
    @body[:content]       = content 
    @body[:donation_page] = donation_page
    content_type "text/html"
  end
  
end
