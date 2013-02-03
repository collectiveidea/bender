Bender::Application.routes.draw do

  namespace :admin do
    resources :beer_taps
    resources :kegs
  end


end
