Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants_lookup#index"
      get "/items/find_all", to: "items_lookup#index"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end

      resources :items do
        resources :merchant, only: [:index], controller: "item_merchants"
      end

      
    end
  end
end
