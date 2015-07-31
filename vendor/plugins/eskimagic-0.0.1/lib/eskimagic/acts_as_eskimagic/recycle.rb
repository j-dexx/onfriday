module Eskimagic
  module ActsAsEskimagic
    module Recycle
      
      def self.included(base)
        base.send :extend, ClassMethods
      end
      
      def destroy
        if recycled
          super
        else
          update_attributes(:recycled => 1, :recycled_at => Time.now)
        end
      end
      
      def restore
        update_attributes(:recycled => 0, :recycled_at => nil)
      end
      
      module ClassMethods
      
      end
      
    end
  end
end