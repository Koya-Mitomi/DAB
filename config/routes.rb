Rails.application.routes.draw do
  get 'sessions/new'
  get "/signup", to: "users#new"
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get "/income", to:"incomes#index"
  get "/income_register", to: "incomes#new"
  delete 'incomes/:id' => 'incomes#destroy'
  patch 'incomes/:id'  => 'incomes#update'
  resources :users
  resources :incomes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
