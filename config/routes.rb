Rails.application.routes.draw do
  resources :users do
    get 'transactions/new', to: 'custom#show_user_transactions'
    get 'transactions/max_debit/:max', to: 'custom#max_debit'
    get 'transactions/graph_data', to: 'custom#graph_data'
    get 'transactions/', to: 'transactions#show_user_transactions'
    post 'transactions/send_otp', to: 'custom#send_otp'
    post 'transactions/send_transaction_history', to: 'custom#send_transaction_history'
    resources :transactions, except: :index
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
