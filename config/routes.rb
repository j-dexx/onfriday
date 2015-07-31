ActionController::Routing::Routes.draw do |map|
  map.resources :spotlights, :only => [:index, :show]

  map.resources :faqs
  map.root :controller => "web", :action => "index"
  map.resources :basket_items, :only => [:edit, :update, :new, :create], :member => {:edit_donation => :get, :update_donation => :put}
  map.resources :addresses
  map.resources :promo_codes
  map.resources :price_ranges
  map.resources :product_stories
  map.resources :brands
  map.resources :product_images
  map.resources :order_items, :member => {:voucher => :get, :resend_voucher_email => :get, :download_voucher_pdf => :get}
  map.resources :orders
  map.resources :users, :member => {:voucher => :get, :activate_voucher => :post, :credit => :get}
  map.resources :testimonials
  map.resources :donation_pages, :only => [:index, :show], :as => "donate", :member => {:email => :get, :send_email => :post, :convert => [:get, :post]} do |donation_pages|
    donation_pages.resources :basket_items, :only => [], :collection => {:new_donation => :get, :create_donation => :post}
    donation_pages.resources :donations, :only => [:index]
  end
  map.resources :products, :collection => {:search => :get, :index_clean => :get, :new => :get, :sale => :get} do |products|
    products.resources :donation_pages, :except => [:index]
  end
  map.resources :articles
  map.resources :page_nodes, :as => "page"
  map.resources :page_contents
  map.basket 'basket', :controller => 'baskets'
  map.login 'login', :controller => 'user_sessions', :action => 'new'  
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
  map.voucher 'voucher', :controller => 'web', :action => 'voucher'
  map.resources :password_resets
  map.resources :newsletter_subscribers, :except => :show, :collection => {:unsubscribe => [:get, :post]}
  map.resources :user_sessions  

  map.namespace :admin do |admin|

    admin.resources :spotlights, :except => [:show], :collection => {:index_update => :post}

    admin.resources :donations, :except => [:show]

    admin.resources :donation_pages, :except => [:show]
    admin.resources :faqs, :except => [:show]
    admin.resources :baskets, :member => {:convert_to_order => :get, :keep => :get}
    admin.resources :newsletter_subscribers, :except => [:show]
    admin.resources :promo_codes, :except => [:show]
    admin.resources :price_ranges, :except => [:show]
    admin.resources :shipping_options, :except => [:show]
    admin.resources :product_stories, :except => [:show]
    admin.resources :brands, :except => [:show]
    admin.resources :product_images, :except => [:show]
    admin.resources :product_pictures, :except => [:show]
    admin.resources :order_items, :except => [:show]
    admin.resources :orders, :except => [:show]
    admin.resources :bookings, :except => [:show]
    admin.resources :users, :except => [:show]
    admin.resources :testimonials, :except => [:show]
    admin.resources :products, :except => [:show], :collection => {:order => :post, :sort => :get}
    admin.resources :articles, :except => [:show]
   	admin.resources :page_nodes, :except => [:show]
    admin.resources :jargons, :except => [:show]
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
