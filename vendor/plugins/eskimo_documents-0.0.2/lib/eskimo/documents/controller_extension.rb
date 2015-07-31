module Eskimo::Documents::ControllerExtension

  def self.included(base)
    base.extend Eskimo::Documents::ControllerExtension::BaseMethods
  end

  class Config
  
    attr_reader :model
    
    def initialize(in_model)
      @model = in_model
    end
    
  end
  
  module ClassMethods

    def index_documents
      @model = self.class.config.model
      @object = @model.find(params[:id])
      render "admin/shared/index_documents"
    end
    
    def index_document
      @model = self.class.config.model
      @object = @model.find(params[:id])
      render "admin/shared/index_document", :layout =>  "admin_popup"
    end
    
    ## helper method to determine if any of the objects attachments have changed?
    #
    def documents_changed?(params)
      return true
    end
    
  end
  
  module BaseMethods
  
    def handles_documents_for(in_model)
      @config = Eskimo::Documents::ControllerExtension::Config.new(in_model)
      send :include, Eskimo::Documents::ControllerExtension::ClassMethods
    end  
    
    def config
      @config || self.superclass.instance_variable_get('@config')
    end
    
  end

end
