Phecda::Application.routes.draw do
  resources :sku_bindings

  root :to => 'home#index'
  get '/auth/taobao/callback' => 'oauths#taobao'
  devise_for :users
  resources :trades
  resources :sku_bindings
  resources :sellers

  namespace :tb do
    resources :products,  only: [:index, :show, :edit, :update]
    # resources :skus
  end

  namespace :sys do
    resources :products
    resources :properties
    resources :categories
    resources :skus
  end

  namespace :core do
    resources :areas
    resources :logistics
    resources :logistic_areas,  only: [:index, :new, :create, :destroy] do
      collection do
        get   :area_nodes
        post  :node_click
      end
    end
    resources :roles
    resources :sellers
    resources :seller_areas,  only: [:index, :new, :create, :destroy] do
      collection do
        get   :area_nodes
        post  :node_click
      end
    end

    resources :stocks do
      resources   :stock_bills
      resources   :stock_in_bills
      resources   :stock_out_bills
      resources   :stock_products
    end
    resources :user_roles
  end

  namespace :edm do
    resources :tasks
  end

  namespace :admin do
    resources :permissions
    resources :account_permissions do
      collection do
        get   :edit_permissions
        post  :update_permissions
      end
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
