module SubscribesTo
  require File.dirname(__FILE__) + "/eskimo/subscribes/model_extension"
  ActiveRecord::Base.send :include, Eskimo::Subscribes::ModelExtension
  ActiveRecord::Base.send :include, Eskimo::Subscribes::FormExtension
end
