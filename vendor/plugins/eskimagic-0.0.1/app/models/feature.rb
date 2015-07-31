class Feature < ActiveRecord::Base
  
  named_scope :super_admin, :conditions => { :super_admin_only => true }, :order => "position"
  named_scope :normal, :conditions => { :super_admin_only => false }, :order => "position"
  named_scope :menu, :conditions => {:menu => true}, :order => "position"
  named_scope :not_menu, :conditions => {:menu => false}, :order => "position"
  named_scope :permission, :conditions => {:permission => true, :super_admin_only => false}, :order => "name"
  named_scope :location, lambda { |location| { :conditions => ['location LIKE ?', location] } }
  named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :condtions => ["recycled = ?", false]
  
  def active?
  	!recycled? && display?
  end
  
  acts_as_eskimagical
  
  has_and_belongs_to_many :roles
  
  def self.find_by_controller_and_action(controller, action)
    feature = Feature.find(:first, :conditions => ["controller = ? and action = ?", controller, action]) || Feature.find(:first, :conditions => ["controller = ? and action = ?", controller, ""]) || Feature.find(:first, :conditions => ["controller = ?", controller])
  end
  
  def path
    if controller? && action?
      {:controller => controller, :action => action}
    elsif controller?
      {:controller => controller}
    else
      nil
    end
  end
end
