Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


scope module: 'api' do
  post 'user_token' => 'user_token#create'  
  resources :users
  resources :password_resets,     only: [:create, :update]
  namespace :v1 do
    resources :properties
    end  
  end
end
