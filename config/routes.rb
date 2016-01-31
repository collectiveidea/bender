Rails.application.routes.draw do

  namespace :admin do
    resources :beer_taps
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

    get 'settings' => 'settings#index'
    get 'achievements' => 'metrics#achievements'
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
