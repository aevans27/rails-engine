Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find_all", to: "merchants_lookup#index"
      get "/merchants/find", to: "merchants_lookup#show"
      get "/items/find_all", to: "items_lookup#index"
      get "/items/find", to: "items_lookup#show"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end

      resources :items do
        resources :merchant, only: [:index], controller: "item_merchants"
      end
    end
  end
end
