module Eskimagic
  module ActsAsEskimagic
    module Version
      
      def self.included(base)
        base.send :extend, ClassMethods
        base.named_scope(:masters, :conditions => "extra_infos.master_version_id IS NULL", :include => "extra_info")
        base.named_scope(:versions, lambda { |*args| {:conditions => ["extra_infos.master_version_id = ?", (args.first)], :include => "extra_info"}})
      end
      
      def master_version
        if extra_info && extra_info.master_version_id?
          self.class.find(extra_info.master_version_id)
        else
          nil
        end
      end
      
      def master?
        if self.master_version == nil
          true
        else
          false
        end
      end
      
      def master_version=(object)
        extra_info.master_version_id = object.id
        extra_info.save
      end
      
      def versions
        self.class.find(:all, :conditions => "extra_infos.master_version_id = #{self.id}", :include => "extra_info")
      end
      
      def version_ids
        self.class.find(:all, :conditions => "extra_infos.master_version_id = #{self.id}", :include => "extra_info").collect{|x| x.id}
      end
      
      def activate
      	if master?
      		return
      	else
	        master_version.versions.each do |v|
	          v.master_version = self
	        end
	        master_version.master_version = self
	        extra_info.update_attribute(:master_version_id, nil)
	      end
      end
      
      def branch
        branch = self.clone
        branch.save # have to save here so an extra_info object is created for the version
        if self.master?
        	branch.master_version = self
        else
        	branch.master_version = self.master_version
        end
        branch
      end
      
      def save_as_new_version(*attributes)
        new_version = self.class.new(*attributes)
        if new_version.save
          if self.is_master_version?
            new_version.master_version = self
          else
            new_version.master_version = self.master_version
          end
          true
        else
          false
        end
      end
        
      def is_version?
        extra_info.master_version_id?
      end
      
      def is_master_version?
        !extra_info.master_version_id?
      end
      
      module ClassMethods
        
        def version?
          true
        end
          
      end
      
    end
  end
end