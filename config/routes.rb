Ticketee4::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'projects#index'
  
  # nested resource
  resources :projects do
    resources :tickets do
      # We use collection because the search action will act on a collection of ticket objects
      collection do
        get :search
      end
      # We use member because the watch action will act on a single ticket object
      member do
        post :watch
      end
    end
  end
  
  resources :tickets do
    resources :comments
    resources :tags do
      member do
        delete :remove # Allows to define a new action in the tags controller => remove. Will act on one object
      end
    end
  end

  resources :users
  
  # admin namespace
  namespace :admin do
    root :to => "base#index"
    resources :users do
      resources :permissions
      # this route will respond to PUT requests
      # the controller and action are defined by to:
      # the as: defines the path to that action as set_permissions,
      # we can use admin_user_set_permissions_path
      put "permissions", to: "permissions#set", as: "set_permissions"
    end
    resources :states do
      member do
        get :make_default
      end
    end
  end
  
  delete '/signout', to: 'sessions#destroy'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  
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
