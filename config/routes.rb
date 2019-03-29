Rails.application.routes.draw do
  root 'home#index'
  get '/authorize' => 'auth#gettoken'
  get '/feedbacks', to: 'feedbacks#new'
  post '/feedbacks', to: 'feedbacks#create'
  resources :feedbacks
end
