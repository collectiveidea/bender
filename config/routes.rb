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
  resources :temperature_sensors
  resources :users

  root :to => 'homepage#index'

end
