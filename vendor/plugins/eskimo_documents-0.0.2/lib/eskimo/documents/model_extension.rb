module Eskimo::Documents::ModelExtension

  def self.included(base)
    base.extend Eskimo::Documents::ModelExtension::BaseMethods
  end
  
  class Config
  
    attr_reader :attributes
    
    def initialize(in_attributes)
      @attributes = in_attributes
    end
    
  end

  module BaseMethods
  
    def has_documents
      send :extend, Eskimo::Documents::ModelExtension::ClassMethods
      send :include, Eskimo::Documents::ModelExtension::InstanceMethods
      send("documents").each_key do |k|
        send :attr_accessor, ("delete_#{k}").to_sym
        send :attr_accessor, ("store_#{k}").to_sym
        send :attr_accessor, ("existing_document_for_#{k}").to_sym
      end
      send :before_save, :process_documents
      send :after_save, :store_documents
    end
    
    def may_contain_documents(attributes)
      send :extend, Eskimo::Documents::ModelExtension::ContainerClassMethods
      send :include, Eskimo::Documents::ModelExtension::ContainerInstanceMethods
      if attributes.class == String || attributes.class == Symbol
        attributes = [attributes]
      end
      @config = Eskimo::Documents::ModelExtension::Config.new(attributes)
      send :before_destroy, :destroy_assets
      send :after_save, :process_contained_documents, :if => Proc.new{ |object| object.document_sweep? }
    end
    
    def config
      @config || self.superclass.instance_variable_get('@config')
    end
    
    def has_attached_document(name, options={})
      defaults = {
        :url => "/assets/:class/:id/:attachment/:style/:basename.:extension",
        :path => ":rails_root/public/assets/:class/:id/:attachment/:style/:basename.:extension",
        :type => "document",
      }
      options = options.merge(defaults)
      has_attached_file(name, options)    
    end
  
  end
  
  module ClassMethods
  
    ## returns hash of documents which an instance of this class has
    #  
    def documents
      all_attachments = attachment_definitions.clone
      all_attachments.delete_if{|k,v| v[:type] != "document"}
    end
    
    ## uses the information the model knows about itself to search the params for anything to indicate an document
    ## has been added and return true if this is the case
    #
    def document_changes?(params)
      for document in self.documents.keys
        if params.include? document.to_sym
          return true
        elsif !params["existing_document_for_#{document.to_s}"].blank?
          return true
        end      
      end
      return false
    end
    
  end
  
  module InstanceMethods
  
    ## if documents delete attribute is true then set the document to nil so paperclip will clean it up
    #
    def process_documents
      self.documents.each_key do |k| 
        if self.send("delete_#{k}") == "1"
          self.send("#{k}=", nil) 
          self.send("#{k}_alt=", nil)
        end
        if !self.send("existing_document_for_#{k}").blank?
          self.send("#{k}=", Document.find(self.send("existing_document_for_#{k}")).document.to_file)
        end
      end
    end
    
    ## if documents store attribute is true create a new document object for it for re-use
    #
    def store_documents
      self.documents.each_key do |k|
        if self.send("store_#{k}") == "1"
          if self.send("#{k}?")
            document = Document.new
            document.document = self.send(k).to_file
            document.save
          end
        end
      end
    end
    
    ## call attachments from instance instead of class
    #
    def documents
      self.class.documents
    end
    
  end
  
  module ContainerClassMethods
  
    ## method to determine which attributes (columns in table) of an object may contain document references
    #
    def document_containers
      self.config.attributes
    end
  
  end
  
  module ContainerInstanceMethods
    
    ## returns array of attributes to check for documents
    ## they are defined with the may_contain_documents method used in the model
    #
    def document_containers
      self.class.document_containers
    end
    
    ## checks if any documents need moving to the objects asset folder and deletes any documents which are no longer used
    #
    def document_sweep?
      results = false
      all_contents = ""
      for attribute in self.document_containers
        contents = self.send(attribute)
        if !contents.blank?
          new_matches = contents.scan(/\/stored_documents\/[\w]*\/[\w. ]*/)
          results = true if new_matches.length > 0 
          all_contents += contents
        end
      end
      pwd = Dir.pwd
      document_dir = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_documents"
      FileUtils.mkdir_p(document_dir) unless File.directory?(document_dir)
      Dir.chdir document_dir
      file_dirs = Dir.glob("*")
      for dir in file_dirs
        #raise all_contents.to_yaml
        #raise file_dirs.to_yaml
        FileUtils.rm_rf(File.join(document_dir, dir)) unless all_contents.include?(dir)
      end
      Dir.chdir pwd
      return results
    end
    
    def destroy_assets
      document_dir = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}"
      FileUtils.rm_rf(document_dir) if File.directory?(document_dir)
    end
  
    ## find any references to stored documents in the document_containers and move those documents to the 
    ## correct location and update the references
    #
    def process_contained_documents
      require 'active_support/secure_random'
      
      document_folder = "#{RAILS_ROOT}/public/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_documents"
      public_document_folder = "/assets/#{self.class.to_s.pluralize.underscore}/#{self.id}/contained_documents"
      
      FileUtils.mkdir(document_folder) unless File.directory?(document_folder)
      
      for attribute in self.document_containers
        contents = self.send(attribute)
        matches = contents.scan(/\/stored_documents\/[\w]*\/[\w. -]*/).uniq
        for match in matches
          match_file_name = match.gsub(/\/stored_documents\/[\w ]*\//, '')
          random_folder_name = ActiveSupport::SecureRandom.hex(6).to_s
          FileUtils.mkdir("#{document_folder}/#{random_folder_name}")
          FileUtils.cp "#{RAILS_ROOT}/public/assets#{match}", "#{document_folder}/#{random_folder_name}/#{match_file_name}"
          self.send("#{attribute.to_s}=", contents.gsub("../../../assets#{match}", "../../assets#{match}"))
          self.send("#{attribute.to_s}=", contents.gsub("../../assets#{match}", "#{public_document_folder}/#{random_folder_name}/#{match_file_name}"))
        end
      end
      self.save
    end
  
  end
    
end
