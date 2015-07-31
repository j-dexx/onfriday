module Eskimagic
  module CoreFeatures
    module ExtraValidations
      
      ActiveRecord::Base.class_eval do
        
        def self.validates_is_website(*attr_names)
          validates_each(attr_names) do |record, attr_name, value|
            unless value.nil? || value.blank?
              record.errors.add(attr_name, ' should include http://') unless value =~ /(http:\/\/.*)/i
            end
          end
        end
        
        def self.validates_is_email(*attr_names)
          validates_each(attr_names) do |record, attr_name, value|
            unless value.nil? || value.blank?
              record.errors.add(attr_name, ' does not look like an email address.') unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            end
          end
        end
        
      end      
        
    end  
  end
end