class Image < ActiveRecord::Base

  MaxWidth = 600
  MaxHeight = 400
  
  has_attached_file :image, 
    :url => "/assets/stored_images/:style/:id_:basename.:extension",
    :path => ":rails_root/public/assets/stored_images/:style/:id_:basename.:extension",
    :styles => {:original => "700x500>", :small => "100x100#"},
    :convert_options => '-strip -colorspace RGB -resample 72'
    
  validates_attachment_presence :image
  
  named_scope :newest, :order => "created_at DESC"
  
  def crop(x, y, width, height, new)
    require 'RMagick'
    old_image = Magick::Image::read(self.image.path).first
    new_image = old_image.crop(x.to_i, y.to_i, width.to_i, height.to_i, true)
    if new
      temp_folder = "#{RAILS_ROOT}/public/assets/temp"
      FileUtils.mkdir(temp_folder) unless File.directory?(temp_folder)
      new_image.write("#{temp_folder}/#{self.image_file_name}")
      new_stored_image = Image.new
      new_stored_image.image = File.new("#{temp_folder}/#{self.image_file_name}", "r")
      if new_stored_image.save
        result = true
      else
        result = false
      end
      FileUtils.rm_rf(temp_folder)
      return result
    else
      new_image.write(self.image.path)
      self.image.reprocess!
      return true
    end
  end
  
  def self.original_dimensions(image)
    geometry = Paperclip::Geometry.from_file(image.to_file)
    original_width = geometry.width
    original_height = geometry.height
    return original_width, original_height
  end
  
  def self.original_width(image)
    original_width, original_height = self.original_dimensions(image)
    original_width
  end
  
  def self.original_height(image)
    original_width, original_height = self.original_dimensions(image)
    original_height
  end
  
  def self.scaled_dimensions(image)
    actual_width, actual_height = self.original_dimensions(image)
    scaled_width = actual_width
    scaled_height = actual_height
    if actual_width > MaxWidth
      scalar = MaxWidth/actual_width
      scaled_width = scaled_width * scalar
      scaled_height = scaled_height * scalar
    end
    if scaled_height > MaxHeight
      scalar = MaxHeight/scaled_height
      scaled_height = scaled_height * scalar
      scaled_width = scaled_width * scalar
    end
    return scaled_width, scaled_height
  end

  def self.scaled_width(image)
    width, height = self.scaled_dimensions(image)
    width
  end
  
  def self.scaled_height(image)
    width, height = self.scaled_dimensions(image)
    height  
  end
  
  def self.scalar(image)
    return self.scaled_width(image)/self.original_width(image)
  end
  
  def self.detailed_dimensions(model, image, crop)
    crop = crop.to_sym
    style = model.crops(image)[crop]
    if !style.include?('x') # 600 / 600> / 600^
      width = style
      height = nil
    elsif style[0..0] == 'x' # x600 / x600> / x600^
      width = nil
      height = style
    elsif style.include?("#") # 600x600#
      width = style.split('x').first
      height = style.split('x').last
    else # 600x600
      width = nil
      height = nil
    end
    return width, height  
  end
  
  def self.fixed_dimensions(model, image, crop)
    width, height = Image.detailed_dimensions(model, image, crop)
    if width then width = width.gsub(/\D/, '') else width = nil end
    if height then height = height.gsub(/\D/, '') else height = nil end
    return width, height
  end

end
