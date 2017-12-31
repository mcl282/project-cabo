Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  scope module: 'api' do
    post 'user_token' => 'user_token#create'  
    resources :password_resets,     only: [:create, :update]
    namespace :v1 do
      resources :users
      resources :properties
      resources :charges
      resources :transfer_customers
      resources :transfer_sources
    end  
    namespace :webhooks do
      resources :dwolla_webhooks, only: [:create]
    end
  end

end
