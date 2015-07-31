ActionController::Routing::Routes.draw do |map|

  map.connect ":controller/index_images/:id", :action => "index_images"
  map.connect ":controller/index_image/:id/:image", :action => "index_image"
  map.connect ":controller/frame/:id/:image/:crop", :action => "frame"
  map.connect ":controller/execute_frame/:id/:image/:crop", :action => "execute_frame"
  map.connect ":controller/add_whitespace/:id/:image", :action => "add_whitespace"
  
  map.namespace :admin do |admin|
    admin.resources :images, :except => [:show], :member => {:update_stored_images => :post}, :collection => {:execute_frame => [:get, :post], :update_stored_images => :post}
    admin.resources :image_tiny_mces, :member => {:insert => :get}, :collection => {:execute_frame => [:get, :post]}
  end

end
