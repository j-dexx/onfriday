class PageNode < ActiveRecord::Base
  
	named_scope :active, :conditions => ["recycled = ? AND display = ?", false, true]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :roots, :conditions => {:parent_id => nil}
  named_scope :position, :order => "position"
  named_scope :controller_action, lambda { |c, a| { :conditions => ["controller = ? AND action = ?", c, a] } }
  named_scope :controller, lambda { |c| { :conditions => ["controller = ?", c] } }
  named_scope :models, :conditions => "model IS NOT NULL AND model != ''"
  named_scope :navigation, :conditions => {:display_in_navigation => true, :display => true}
  named_scope :can_have_children, :conditions => {:can_have_children => true}
  named_scope :can_be_deleted_or_edited, :conditions => ["can_be_deleted = ? OR can_be_edited = ?", true, true]
  
  after_save { ErrorPages.regenerate }
  
  has_friendly_id :url
  
  acts_as_eskimagical :recycle => true
  acts_as_tree :order => "position"
  
  has_many :page_contents, :dependent => :destroy
  accepts_nested_attributes_for :page_contents
  
  validates_presence_of :name
  validates_uniqueness_of :name, :message => "must be unique"
  validates_format_of :name, :with => /^[\w\d\- ]+$/
  validates_uniqueness_of :url
  
  before_validation :set_url
  
  def set_url
  	self.url = name.downcase.gsub(' ','-')
  end
  
  def self.contact_us
  	PageNode.find_by_name("Contact Us")
  end
  
  # START SITE SPECIFIC
  #
  
  def self.terms_and_conditions
    PageNode.find_by_name("Terms and Conditions")
  end
  
  #
  # END SITE SPECIFIC
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  def sections
  	page_nodes = []
  	page_node = self.parent
  	while page_node
  		page_nodes << page_node
  		page_node = page_node.parent
  	end
  	page_nodes.reverse
  end
  
  def sections_string
  	sections.collect{|s| s.name}.join(" / ")
  end
  
  def sections_name
  	(sections.collect{|s| s.name} << self.name).join(" / ")
  end
  
  def path
    if controller?
      {:controller => controller, :action => action}
    else
    	if !active_content.main_content? && children.length > 0
    		children.sort_by{|x| x.position}.first.path
    	else
    		self
    	end
    end
  end
  
  def admin_path
  	if controller? && !action?
  		{:controller => "admin/#{controller}"}
  	else
  		{:controller => "admin/page_nodes", :action => "edit", :id => self.id}
    end
  end
  
  def active_content
  	if page_contents.length > 1
  		page_contents.select{|x| x.active?}.first || page_contents.first
  	elsif page_contents.length == 1
  		page_contents.first
  	else
  		page_contents.build(:active => false)
  	end
  end
  
  def navigation_title
  	if active_content && active_content.navigation_title?
  		active_content.navigation_title
  	else
  		name
  	end
  end
  
  def title
  	if active_content && active_content.title
  		active_content.title
  	else
  		name
  	end
  end
  
  def style
  	return stylesheet if stylesheet?
  	page_node = parent
    while page_node != nil do
    	return page_node.stylesheet if page_node.stylesheet?
    	page_node = page_node.parent
    end
    return nil
  end
  
  def css_class
  	style.gsub("webstyle_","").gsub(".css","")
  end
  
  def likely_layout
  	page_node = self
    while page_node != nil do
    	puts page_node.title
    	return page_node.layout if page_node.layout?
    	page_node = page_node.parent
    end
    return "basic"
  end
  
  def active?
  	display? && display_in_navigation
  end
  
end
