ActionController::Routing::Routes.draw do |map|

  map.connect ":controller/index_documents/:id", :action => "index_documents"
  map.connect ":controller/index_document/:id/:document", :action => "index_document"

  map.namespace :admin do |admin|
    admin.resources :documents, :except => [:show], :collection => {:update_stored_documents => :post}
    admin.resources :document_tiny_mces, :member => {:insert => :get}
  end

end
