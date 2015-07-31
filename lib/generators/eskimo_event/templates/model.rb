class <%= class_name %> < ActiveRecord::Base
	
  acts_as_eskimagical
	acts_as_taggable_on :tags
	
	validates_presence_of :start_date, :name
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ? AND ((end_date IS NOT NULL AND end_date >= ?) OR (end_date IS NULL AND start_date >= ?))", false, true, Date.today, Date.today]
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :start_year, lambda{|year| {:conditions => ["year(start_date) = ?", year]} }
  named_scope :start_month, lambda{|month| {:conditions => ["month(start_date) = ?", month]} }
  named_scope :end_year, lambda{|year| {:conditions => ["year(end_date) = ?", year]} }
  named_scope :end_month, lambda{|month| {:conditions => ["month(end_date) = ?", month]} }
  named_scope :upcoming, :order => "start_date"
  
  has_attached_image :image, :styles => {:index => "80x80#", :show => "200"}
  has_images
  
  may_contain_images :main_content
  
  def active?
  	return false if !display?
  	return false if recycled?
  	return false if (end_date? && end_date < Date.today)
  	return false if (!end_date? && start_date < Date.today)
  	true
  end
  
  def self.years
    self.active.collect{|a| a.start_date.year}.uniq.sort
  end
  
  def self.months(year)
    self.active.start_year(year).collect{|a| a.start_date.month}.uniq.sort
  end  
  
end
