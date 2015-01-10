Rails.application.routes.draw do

  get 'welcome/index'
  root 'welcome#index'
  post 'auth/steam/callback' => 'welcome#auth_callback'

end
