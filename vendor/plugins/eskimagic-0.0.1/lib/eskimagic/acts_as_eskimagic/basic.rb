module Eskimagic
  module ActsAsEskimagic
    module Basic
        
      def self.included(base)
        base.send :extend, ClassMethods
        base.send :before_create, :set_creator
        base.send :before_update, :update_updater
        base.belongs_to :creator, :class_name => 'Administrator', :foreign_key => 'created_by'
        base.belongs_to :updater, :class_name => 'Administrator', :foreign_key => 'updated_by'
      end
      
      def set_creator
        creator = nil
        begin
          if AdministratorSession.find && AdministratorSession.find.administrator
            creator = AdministratorSession.find.administrator.id
          end
        rescue
        end
        self.created_by = creator
      end
      
      def update_updater
        updater = nil
        begin
          if AdministratorSession.find && AdministratorSession.find.administrator 
            updater = AdministratorSession.find.administrator.id
          end
        rescue
        end
        self.updated_by = updater
      end
      
      def name
        begin
          super
        rescue
          "#{self.class} #{self.id}"
        end
      end
      
      def summary
        begin
          super
        rescue
          name
        end
      end
      
      def version?
        false
      end
      
      def link?
        false
      end
      
      def search_string_1
        name
      end
      
      def search_string_2
        summary
      end
      
      def search_string_3
        search_string = ""
        self.attributes.each_value{|v| search_string << ' ' << v.to_s.downcase.gsub(/[^\w ]/, '')}
        search_string
      end
      
      
      module ClassMethods
        
        def search_string
          self.class_name.to_s.downcase.gsub(/[^\w ]/, '')
        end
        
      end
    
    end  
  end
end
