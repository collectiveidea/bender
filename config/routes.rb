Rails.application.routes.draw do

  namespace :admin do
    resources :beer_taps do
      put 'toggle-cleaning' => 'beer_taps#toggle_cleaning'
    end

    resources :kegs do
      resources :pours, only: [:index, :destroy]

      get    'tap' => 'kegs#list_taps'
      put    'tap' => 'kegs#tap_keg'
      delete 'tap' => 'kegs#untap_keg'
    end
    resources :temperature_sensors, except: [:new, :create] do
      collection do
        get "all_graphs"
      end
    end

    resources :users

    get 'settings' => 'settings#index'
    get 'achievements' => 'metrics#achievements'
  end

  namespace :api do
    namespace :v1 do
      resources :auth, only: [:create]
      resources :taps, only: [:index], controller: "beer_taps"
      resources :pours, only: [:index, :show]
      resources :users, only: [] do
        resources :stats, only: [:index]
      end
    end
  end

  get 'admin' => 'admin#dashboard'

  resources :kegs
  resources :pours do
    get 'volume' => 'pours#volume'
  end
  resources :users

  get "activity/recent(/:limit)(.:format)" => "activity#recent", as: "recent_activity"
  get "activity/user/:user_id(/:limit)(.:format)" => "activity#user_recent", as: "user_activity"

  get "temperature_sensors/:sensor_id/:duration/:start_timestamp.:format" => "temperature_sensors#readings", as: "temperature_sensor_readings"

  root :to => 'homepage#index'

end
