class <%= class_name %> < ActiveRecord::Base
	
  acts_as_eskimagical
	acts_as_taggable_on :tags
	
	validates_presence_of :headline, :date
  
	named_scope :position, :order => "position"
  named_scope :active, :conditions => ["recycled = ? AND display = ? AND date <= ?", false, true, Date.today], :order => "date DESC"
  named_scope :recycled, :conditions => ["recycled = ?", true]
  named_scope :unrecycled, :conditions => ["recycled = ?", false]
  named_scope :year, lambda{|year| {:conditions => ["year(date) = ?", year]} }
  named_scope :month, lambda{|month| {:conditions => ["month(date) = ?", month]} }
  
  has_attached_image :image, :styles => {:index => "80x80#", :show => "200"}
  has_images
  
  may_contain_images :main_content
  
  def active?
  	display? && !recycled? && date <= Date.today
  end
  
  def name
    headline
  end

  def self.years
    self.active.collect{|a| a.date.year}.uniq.sort
  end
  
  def self.months(year)
    self.active.year(year).collect{|a| a.date.month}.uniq.sort
  end
  
  def self.latest(count=1)
  	if count > 1
    	self.active[0..(count-1)]
    else
    	self.active.first
    end
  end
  
  
end
