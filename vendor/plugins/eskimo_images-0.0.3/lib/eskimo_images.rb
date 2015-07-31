module EskimoImages
  
  require File.dirname(__FILE__) + "/eskimo/images/controller_extension"
  require File.dirname(__FILE__) + "/eskimo/images/model_extension"
  require File.dirname(__FILE__) + "/eskimo/images/form_extension"

  ActionView::Base.send :include, Eskimo::Images::FormExtension
  ActionController::Base.send :include, Eskimo::Images::ControllerExtension
  ActiveRecord::Base.send :include, Eskimo::Images::ModelExtension
  
end
