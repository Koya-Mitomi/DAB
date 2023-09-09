Rails.application.routes.draw do
  get 'sessions/new'
  get "/signup", to: "users#new"
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/check", to: "sum#check"
  get "/income_sum", to: "sum#income_sum"
  get "/expenditure_sum", to: "sum#expenditure_sum"
  get "/income_sum_year", to: "sum#income_sum_year"
  get "/expenditure_sum_year", to: "sum#expenditure_sum_year"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :incomes do
    resources :income_amounts, only: [:new, :edit, :create, :update, :destroy]
  end
  resources :expenditures do
    resources :expenditure_amounts, only: [:new, :edit, :create, :update, :destroy]
  end

  resources :users
  resources :expenditures
  resources :expenditure_amounts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
