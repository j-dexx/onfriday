module Eskimo::Images::ModelExtension

  def self.included(base)
    base.extend Eskimo::Images::ModelExtension::BaseMethods
  end
  
  class Config
  
    attr_reader :attributes
    
    def initialize(in_attributes)
      @attributes = in_attributes
    end
    
  end

  module BaseMethods
  
    def has_images
      send :extend, Eskimo::Images::ModelExtension::ClassMethods
      send :include, Eskimo::Images::ModelExtension::InstanceMethods
      send("images").each_key do |k|
        send :attr_accessor, ("delete_#{k}").to_sym
        send :attr_accessor, ("store_#{k}").to_sym
        send :attr_accessor, ("existing_image_for_#{k}").to_sym
      end
      send :before_save, :process_images
      send :after_save, :store_images
    end
    
    def may_contain_images(attributes)
      send :extend, Eskimo::Images::ModelExtension::ContainerClassMethods
      send :include, Eskimo::Images::ModelExtension::ContainerInstanceMethods
      if attributes.class == String || attributes.class == Symbol
        attributes = [attributes]
      end
      @config = Eskimo::Images::ModelExtension::Config.new(attributes)
      send :before_destroy, :destroy_assets
      send :after_save, :process_contained_images, :if => Proc.new{ |object| object.image_sweep? }
    end
    
    def config
      @config || self.superclass.instance_variable_get('@config')
    end
    
    def has_attached_image(name, options={})
      defaults = {
        :convert_options => '-strip -colorspace RGB -resample 72',
        :url => "/assets/:class/:id/:attachment/:style/:basename.:extension",
        :path => ":rails_root/public/assets/:class/:id/:attachment/:style/:basename.:extension",
        :type => "image",
      }
      options = options.merge(defaults)
      options[:styles] ||= {}
      # if original isn't defined constrain its dimensions
      options[:styles] = options[:styles].merge(:original => "700x500>") unless options[:styles][:original]
      # force the sample style in
      options[:styles] = options[:styles].merge(:sample => "100x100#")
      has_attached_file(name, options)    
    end
  
  end
  
  module ClassMethods
  
    ## returns hash of images which an instance of this class has
    #  
    def images
      all_attachments = attachment_definitions.clone
      all_attachments.delete_if{|k,v| v[:type] != "image"}
    end
    
    ## return hash which define what crops an image has
    #
    def crops(image)
      image = image.to_sym
      if images[image][:styles].blank?
        {}
      else
        images[image][:styles].delete_if{|k,v| k == :sample}
      end
    end
    
    ## uses the information the model knows about itself to search the params for anything to indicate an image
    ## has been added and return true if this is the case
    #
    def image_changes?(params)
      for image in self.images.keys
        if params.include? image.to_sym
          return true
        elsif !params["existing_image_for_#{image.to_s}"].blank?
          return true
        end      
      end
      return false
    end
    
  end
  
  module InstanceMethods
  
    ## if images delete attribute is true then set the image to nil so paperclip will clean it up
    #
    def process_images
      self.images.each_key do |k| 
        if self.send("delete_#{k}") == "1"
          self.send("#{k}=", nil) 
          self.send("#{k}_alt=", nil)
        end
        if !self.send("existing_image_for_#{k}").blank?
          self.send("#{k}=", Image.find(self.send("existing_image_for_#{k}")).image.to_file)
        end
      end
    end
    
    ## if images store attribute is true create a new image object for it for re-use
    #
    def store_images
      self.images.each_key do |k|
        if self.send("store_#{k}") == "1"
          if self.send("#{k}?")
            image = Image.new
            image.image = self.send(k).to_file
            image.save
          end
        end
      end
    end
    
    ## call attachments from instance instead of class
    #
    def images
      self.class.images
    end
   
    def crops(*image)
      self.class.crops(*image)
    end
    
    ## crop the style of this objects image and resize to the correct dimensions
    #
    def execute_crop(image, crop, x, y, width, height)
      require 'RMagick'
      # load in the original image
      old_image = Magick::Image::read(self.send(image).path).first
      # crop it at the desired position
      new_image = old_image.crop(x.to_i, y.to_i, width.to_i, height.to_i, true)
      # scale the image to the correct size if needed
      desired_width, desired_height = Image.detailed_dimensions(self.class, image, crop)
      if desired_width
        clean_desired_width = desired_width.gsub(/\D/, '').to_f
        if desired_width.include?('>')
          new_image.scale!(clean_desired_width/width.to_f) if (width > clean_desired_width)
        elsif desired_width.include?('^')
          new_image.scale!(clean_desired_width/width.to_f) if (width < clean_desired_width)
        else
          new_image.scale!(clean_desired_width/width.to_f)
        end
      elsif desired_height
        clean_desired_height = desired_height.gsub(/\D/, '').to_f
        if desired_height.include?('>')
          new_image.scale!(clean_desired_height/height.to_f) if (height > clean_desired_height)
        elsif desired_height.include?('^')
          new_image.scale!(clean_desired_height/height.to_f) if (height < clean_desired_height)
        else
          new_image.scale!(clean_desired_height/height.to_f)
        end
      end
      FileUtils.mkdir_p(File.dirname(self.send(image).path(crop).to_s))
      new_image.write(self.send(image).path(crop).to_s)
    end
    
    ## add whitespace to the original image
    #
    def add_whitespace(image)
      require 'RMagick'
      # load in the original image
      file_path = self.send(image).path(:original)
      old_image = Magick::Image::read(file_path).first
      geometry = Paperclip::Geometry.from_file(self.send(image).to_file)
      original_width = geometry.width
      original_height = geometry.height
      # add 200 pixels of whitespace
      white_space = 200
      new_image = old_image.extent((original_width + white_space), (original_height + white_space), (white_space/2), (white_space/2))
      # write over the original
      new_image.write(file_path)
    end
    
  end
  
  module ContainerClassMethods
  
    ## method to determine which attributes (columns in table) of an object may contain image references
    #
    def image_containers
      self.config.attributes
    end
  
  end
  
  module ContainerInstanceMethods
    
    ## returns array of attributes to check for images
    ## they are defined with the may_contain_images method used in the model
    #
    def image_containers
      self.class.image_containers
    end
    
    ## checks if any images need moving to the objects asset folder and deletes any images which are no longer used
    #
    def image_sweep?
      results = false
      all_contents = ""
      for attribute in self.image_containers
        contents = self.send(attribute)
        if !contents.blank?
          new_matches = contents.scan(/\/stored_images\/[\w]*\/[\w. ]*/)
          results = true if new_matches.length > 0 
          all_contents += contents
        end
      end
      pwd = Dir.pwd
      image_dir = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_images"
      FileUtils.mkdir_p(image_dir) unless File.directory?(image_dir)
      Dir.chdir image_dir
      files = Dir.glob("*")
      for file in files
        FileUtils.rm(File.join(image_dir, file)) unless all_contents.include?(file)
      end
      Dir.chdir pwd
      return results
    end
    
    def destroy_assets
      image_dir = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}"
      FileUtils.rm_rf(image_dir) if File.directory?(image_dir)
    end
  
    ## find any references to stored images in the image_containers and move those images to the 
    ## correct location and update the references
    #
    def process_contained_images
      require 'active_support/secure_random'
      image_folder = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_images"
      public_image_folder = "/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_images"
      FileUtils.mkdir(image_folder) unless File.directory?(image_folder)
      for attribute in self.image_containers
        contents = self.send(attribute)
        if contents
          matches = contents.scan(/\/stored_images\/[\w]*\/[\w. -]*/).uniq
          for match in matches
            match_file_name = match.gsub(/\/stored_images\/[\w ]*\//, '')
            random_file_name = "#{ActiveSupport::SecureRandom.hex(6)}_#{match_file_name}"
            FileUtils.cp "#{RAILS_ROOT}/public/assets#{match}", "#{image_folder}/#{random_file_name}"
            self.send("#{attribute.to_s}=", contents.gsub("../../../assets#{match}", "../../assets#{match}"))
            self.send("#{attribute.to_s}=", contents.gsub("../../assets#{match}", "../../#{public_image_folder}/#{random_file_name}"))
          end
        end
      end
      self.save
    end
  
  end
    
end
