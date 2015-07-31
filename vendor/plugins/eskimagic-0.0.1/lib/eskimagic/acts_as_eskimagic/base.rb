module Eskimagic
  module ActsAsEskimagic
    module Base
      
      def self.included(base)
        base.send :extend, ClassMethods
      end
            
      module ClassMethods
        
        def acts_as_eskimagical(options={})
          send :include, Eskimagic::ActsAsEskimagic::Basic
          if options[:recycle] == true
            send :include, Eskimagic::ActsAsEskimagic::Recycle
          end
          if options[:version] == true
            send :include, Eskimagic::ActsAsEskimagic::Version
          end
        end
        
      end
    
    end  
  end
end

ActiveRecord::Base.send :include, Eskimagic::ActsAsEskimagic::Base