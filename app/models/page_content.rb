class PageContent < ActiveRecord::Base

  has_attached_image :image, :styles => {:large => "325>"}
  has_images

  may_contain_images [:main_content, 
    :be_part_of_it_content_1, 
    :be_part_of_it_content_2, 
    :be_part_of_it_content_3, 
    :be_part_of_it_content_4, 
    :be_part_of_it_content_5, 
    :be_part_of_it_content_6]
    
  may_contain_documents [:main_content, 
    :be_part_of_it_content_1, 
    :be_part_of_it_content_2, 
    :be_part_of_it_content_3, 
    :be_part_of_it_content_4, 
    :be_part_of_it_content_5, 
    :be_part_of_it_content_6]
  
  named_scope :active, :conditions => "active = true"
  
  acts_as_eskimagical :recycle => true
  
  belongs_to :page_node
  belongs_to :brand
  
  validates_presence_of :title, :navigation_title
  
  before_validation :try_and_complete
    
  after_destroy :check_if_last
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  def check_if_last
  	if page_node.page_contents.length == 0
  		page_node.destroy
  	end
  end
  
  def activate
  	page_node.page_contents.each{|pc| pc.update_attribute(:active, false)}
  	self.update_attribute(:active, true)
  end
  
  def title
  	if super.nil? || super.empty?
  		page_node.name
  	else
  		super
  	end
  end
  
  def name
  	page_node.title if page_node
  end
  
  def summary
		require 'rubygems'
		require 'sanitize'
		Sanitize.clean(self.main_content)[0..600] if main_content
  end
  
  protected 
  
  def try_and_complete
  	self.url_title = title.gsub(/\s/,'_').gsub(/[^\w\d_]/, '').downcase if url_title.nil? || url_title.blank?
  	self.navigation_title = title if navigation_title.nil? || navigation_title.blank?
  end
    
end
