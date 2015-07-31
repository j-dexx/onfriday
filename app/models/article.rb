class Article < ActiveRecord::Base
	
	acts_as_eskimagical :recycle => true
	acts_as_taggable_on :tags
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ? AND date <= ?", false, true, Date.today]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :year, lambda{|year| {:conditions => ["year(date) = ?", year]} }
  named_scope :month, lambda{|month| {:conditions => ["month(date) = ?", month]} }
  named_scope :latest, :order => "date"
  
  has_attached_image :image, :styles => {:thumbnail => "100x100#", :large => "250x"}
  has_images
  may_contain_images :body
  may_contain_documents :body
  
  validates_presence_of :name, :date
  
  def active?
  	display? && !recycled? && date <= Date.today
  end
  
  def self.years
    Article.active.collect{|a| a.date.year}.uniq.sort
  end
  
  def self.months(year)
    Article.active.year(year).collect{|a| a.date.month}.uniq.sort
  end
    
  # each model should have a name method, if name is not in the db and a summary method, if summary is not in the db
  # this is used for searching the models
  
  # if you want to tweak the searching for a model define search_string_1, search_string_2 and search_string_3
  # these default to name, summary and attributes, higher number, higher in the search
  
  
end
