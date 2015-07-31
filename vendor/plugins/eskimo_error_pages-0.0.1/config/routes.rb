ActionController::Routing::Routes.draw do |map|

  map.resources :error_pages, :only => [], :collection => {:e404 => :get, :e500 => :get}
  
end
