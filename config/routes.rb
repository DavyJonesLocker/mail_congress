MailCongress::Application.routes.draw do
  post 'search' => 'search#show', :as => 'search'
  root :to => 'home#index'
  post 'letters' => 'letters#create', :as => 'letters'
  post 'payments/new' => 'payments#new', :as => 'new_payment'
  post 'payments' => 'payments#create', :as => 'payments'
end
