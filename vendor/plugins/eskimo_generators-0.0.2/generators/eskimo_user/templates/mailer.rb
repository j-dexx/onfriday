class <%= class_name %>Mailer < ActionMailer::Base
	
	add_template_helper ApplicationHelper
	
	def password_reset_instructions(<%= singular_name %>)  
    @subject                        = "Password Reset Instructions"  
    @from                           = SiteSetting.like("Email").first.value  
    @recipients                     = <%= singular_name %>.email  
    @body[:edit_password_reset_url] = edit_<%= singular_name %>_password_reset_url(<%= singular_name %>.perishable_token)  
    content_type "text/html"  
  end  
    
end
