module Eskimo::Images::ControllerExtension

  def self.included(base)
    base.extend Eskimo::Images::ControllerExtension::BaseMethods
  end

  class Config
  
    attr_reader :model
    
    def initialize(in_model)
      @model = in_model
    end
    
  end
  
  module ClassMethods

    def index_images
      @model = self.class.config.model
      @object = @model.find(params[:id])
      render "admin/shared/index_images"
    end
    
    def index_image
      @model = self.class.config.model
      @object = @model.find(params[:id])
      render "admin/shared/index_image", :layout =>  "admin_popup"
    end    
    
    def frame
      @model = self.class.config.model
      @object = @model.find(params[:id])
      unless params[:lytebox].blank?
        render "admin/shared/frame", :layout =>  "admin_popup"
      else
        render "admin/shared/frame"
      end
    end
    
    def execute_frame
      @model = self.class.config.model
      @object = @model.find(params[:id])
      image = @object.send(params[:image])
      scalar = Image.scalar(image)
      @object.execute_crop(
        params[:image], 
        params[:crop], 
        params[:x1].to_f/scalar,
        params[:y1].to_f/scalar,
        params[:width].to_f/scalar,
        params[:height].to_f/scalar
        )
      unless params[:lytebox].blank?
        redirect_to :action => "index_image", :id => params[:id], :image => params[:image]
      else
        redirect_to :action => "index_images", :id => params[:id]
      end
    end
    
    def add_whitespace
      @model = self.class.config.model
      @object = @model.find(params[:id])
      @object.add_whitespace(params[:image])
      redirect_to :action => "index_images", :id => params[:id]      
    end
    
    ## helper method to determine if any of the objects attachments have changed?
    #
    def images_changed?(params)
      return true
    end
    
  end
  
  module BaseMethods
  
    def handles_images_for(in_model)
      @config = Eskimo::Images::ControllerExtension::Config.new(in_model)
      send :include, Eskimo::Images::ControllerExtension::ClassMethods
    end  
    
    def config
      @config || self.superclass.instance_variable_get('@config')
    end
    
  end

end
