Bender::Application.routes.draw do

  namespace :admin do
    resources :beer_taps
    resources :kegs do
      get    'tap' => 'kegs#list_taps'
      put    'tap' => 'kegs#tap_keg'
      delete 'tap' => 'kegs#untap_keg'
    end
    get 'settings' => 'settings#index'
  end

  resources :kegs
  resources :pours do
    get 'volume' => 'pours#volume'
  end
  resources :users

  get "temperature_sensors/:sensor_id/:duration/:start_timestamp.:format" => "temperature_sensors#readings", as: "temperature_sensor_readings"

  root :to => 'homepage#index'

end
