module EskimoDocuments
  
  require File.dirname(__FILE__) + "/eskimo/documents/controller_extension"
  require File.dirname(__FILE__) + "/eskimo/documents/model_extension"
  require File.dirname(__FILE__) + "/eskimo/documents/form_extension"

  ActionView::Base.send :include, Eskimo::Documents::FormExtension
  ActionController::Base.send :include, Eskimo::Documents::ControllerExtension
  ActiveRecord::Base.send :include, Eskimo::Documents::ModelExtension
  
end
