Invitedly::Application.routes.draw do

  #get 'about' => 'static#about'
  #get 'terms' => 'static#terms'
  #get 'privacy' => 'static#privacy'
  #get 'address_book' => 'contacts#index'  

  /
  resources :contacts, :except => [:index,:show] do
   get :get_facebook_contacts, :on => :collection
  end
  /
  
  devise_for :users, :controllers => { :registrations => "users/registrations",
    :omniauth_callbacks => "users/omniauth_callbacks",
    :sessions => "users/sessions"
     }
  
  resources :occasions, :except => [:index], :path => '' do
    match 'rsvp/verify_email_address' => 'rsvp#verify_email_address', :via => :post
    
    resources :guests, :as => :contacts, :controller => :contacts do
      resources :rsvp
      
    end 
    resources :events, :except => [:show]
  end

     
  root 'static#home'


  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
