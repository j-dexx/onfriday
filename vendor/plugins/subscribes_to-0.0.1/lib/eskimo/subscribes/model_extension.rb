module Eskimo::Subscribes::ModelExtension

  def self.included(base)
    base.extend Eskimo::Subscribes::ModelExtension::BaseMethods
  end
  
  class Config
    attr_reader :args
    
    def initialize(in_args)
      @args = in_args
    end
  end
  
  module BaseMethods
    def subscribes_to(args)
      acts_as_taggable_on :tag_subscribe
      
      @subscription_config = Eskimo::Subscribes::ModelExtension::Config.new(args)
      send :include, Eskimo::Subscribes::ModelExtension::InstanceMethods
    end
    
    def subscription_config
      @subscription_config || self.superclass.instance_variable_get('@subscription_config')
    end
  end
  
  module InstanceMethods
    def tag_subscribe_array
      self.tag_subscribe_list
    end
    
    def tag_subscribe_array=(tags)
      self.tag_subscribe_list = tags.join(", ")
      self.save
    end
    
    def subscription_options
      arr = []
      if self.page_node.layout?
        layout = self.page_node.layout.to_sym 
      else
        layout = :basic
      end
      for model in self.class.subscription_config.args[layout]
        if model.class == Array
          begin
            arr += model[0].tag_counts_on(model[1])
          rescue
          end
        else
          begin
            arr += model.tag_counts_on(:tags)
          rescue
          end
        end
      end
      arr.uniq!
      return arr
    end
    
    def subscriptions
      tag_counts_on(:tag_subscribe)
    end
    
    def subscription_models
      arr = []
      if self.page_node.layout?
        layout = self.page_node.layout.to_sym 
      else
        layout = :basic
      end
      for model in self.class.subscription_config.args[layout]
        if model.class == Array
          begin
            arr += [model[0]]
          rescue
          end
        else
          begin
            arr += [model]
          rescue
          end
        end
      end
      arr.uniq!
      return arr
    end
    
  end

end

