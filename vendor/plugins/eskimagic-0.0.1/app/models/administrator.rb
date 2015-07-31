class Administrator < ActiveRecord::Base
  
  acts_as_authentic
  has_and_belongs_to_many :roles
  
  has_attached_image :image, :styles => {:small => "55x55#"}
  has_images
  
  named_scope :super_admin, :conditions => {:super_admin => true}
  named_scope :normal, :conditions => {:super_admin => false}
  
  def features
    if super_admin?
      Feature.all
    else
      administrators_features = []
      roles.each{|r| r.features.each{|f| administrators_features << f}}
      administrators_features.uniq!
      administrators_features
    end
  end
  
  def all_features?
    roles.collect{|r| r.all_features}.include? true
  end
  
  def has_permission?(controller, action="")
    feature = Feature.find_by_controller_and_action(controller, action)
    if super_admin || feature == nil
      return true
    end
    if all_features? && !feature.super_admin_only
      return true
    end
    if features.include? feature
      return true
    end
    # raise "#{controller} --- #{action}"
    if Administrator.security_exceptions.include?([controller, action])
    	return true
    end
    return false
  end
  
  alias can? has_permission?
  
  def cannot?(controller, action="")
    !self.has_permission?(controller, action)
  end
  
  def looks_like?(name)
    name = name.downcase
    role_names = roles.collect{|r| r.name.downcase}
    role_names.include? name
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    AdminMailer.deliver_password_reset_instructions(self)
  end
  
  def self.security_exceptions
		[
			["admin/administrator_sessions", ""],
			["admin/administrators", "edit_self"],
			["admin/administrators", "update_self"]
		]
	end
	
	def self.colours  
	  colours = []
	  Dir.foreach("#{RAILS_ROOT}/public/stylesheets/") do |filename|
	    match = filename.scan(/^admin_(\w*).css$/i)
	    colours << [match.first.first.humanize.titleize, filename.gsub('.css', '')] if match.length > 0
	  end
	  colours
	end

    
end
