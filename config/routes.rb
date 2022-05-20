Rails.application.routes.draw do


  
  resources :users do 
    get 'transactions' , to: 'transactions#show_user_transactions'
    resources :transactions, except: :index
  end

  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
