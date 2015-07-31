ActionController::Routing::Routes.draw do |map|

  map.admin "admin", :namespace => "admin", :controller => "web", :action => "index"
  map.admin_login "admin/login", :namespace => "admin", :controller => "administrator_sessions", :action => "new"
  map.admin_logout "admin/logout", :namespace => "admin", :controller => "administrator_sessions", :action => "destroy"
  map.admin_recycle_bin "admin/recycle_bin", :namespace => "admin", :controller => "extra_infos", :action => "index"
  
  map.namespace :admin do |admin|
  	admin.resources :password_resets,        :only       => [:new, :create, :edit, :update]
  	admin.resources :documents,              :except     => [:show]
    admin.resources :pictures,               :except     => [:show]
    admin.resources :roles,                  :except     => [:show]
    admin.resources :site_settings,          :except     => [:show],
                                             :collection => {:new_test_script => :get, :new_site_map => :get}
    admin.resources :features,               :except     => [:show],
                                             :collection => {:order => :post}
    admin.resources :administrators,         :except     => [:show],
                                             :collection => {:update_self => [:post, :put]}
    admin.resources :administrator_sessions, :only       => [:new, :create, :destroy]
    admin.resources :extra_infos,            :only       => [:index, :destroy],
                                             :collection => {:destroy_all => :get, :restore_all => :get},
                                             :member     => {:restore => :get, :destroy => :get}
  end

end
