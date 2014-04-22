Invitedly::Application.routes.draw do

  #get 'about' => 'static#about'
  #get 'terms' => 'static#terms'
  #get 'privacy' => 'static#privacy'
  #get 'address_book' => 'guests#index'  

  root 'static#home'

  devise_for :users, :controllers => { :registrations => "users/registrations",
    :omniauth_callbacks => "users/omniauth_callbacks",
    :sessions => "users/sessions"
     }
  
  resources :sign_up
  
  get 'occasions' => 'occasions#index'  
  post 'occasions' => 'occasions#create'
  resources :occasions, :path => '' do

    match 'rsvp/verify_email_address' => 'rsvp#verify_email_address', :via => :post
    match 'rsvp/verify_first_last_name' => 'rsvp#verify_first_last_name', :via => :post
    
    resources :guests do
      post 'import', on: :collection
    end
    get 'guestbook' => 'occasions#guestbook'  
        
    resources :invitations do
      resources :manage, controller: 'invitations/manage'      
      resources :rsvp
    end
    
    resources :events
  end

     
  
  
  
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
