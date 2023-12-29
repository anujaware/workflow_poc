Rails.application.routes.draw do
  get 'home/data' => "home#fetch_data"
  post 'create_records' => "application#create_records"
  put 'update_records' => "application#update_records"
  get 'home/index'
  resources :workflows do
    collection do
      post :broadcast
    end
  end

  resources :iot_services, only: [] do
    collection do
      get 'get_distance'
      get 'get_cost'
    end
  end

  resources :vehicle_bookings do
    get 'complete'
    collection do
      post :search
    end
  end

  direct :homepage do
    "https://rubyonrails.org"
  end

  direct :commentable do |model|
    [ model, anchor: model.dom_id ]
  end

  direct :main do
    { controller: 'pages', action: 'index', subdomain: 'www' }
  end

  # Defines the root path route ("/")
  root "home#index"
end
