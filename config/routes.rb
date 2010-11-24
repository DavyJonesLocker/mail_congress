MailCongress::Application.routes.draw do
  resources :campaigns
  get  'dashboard', :to => 'advocacy_groups#show', :as => 'dashboard'
  get  'sign_up',  :to => 'advocacy_groups#new', :as => 'new_sign_up'
  post 'sign_up',  :to => 'advocacy_groups#create'
  devise_for :advocacy_groups, :controllers => { :sessions => 'sessions' } do
    post 'sign_in',  :to => 'sessions#create'
    get  'sign_out', :to => 'sessions#destroy'
  end
  get  'c/:campaign_id' => 'home#index', :as => 'campaign_permalink'
  post 'search' => 'search#show', :as => 'search'
  post 'letters/preview' => 'letters#show', :as => 'preview_letter'
  post 'payments/new' => 'payments#new', :as => 'new_payment'
  post 'payments' => 'payments#create', :as => 'payments'
  get  'thank-you' => 'thank_you#show', :as => 'thank_you'
  get  'terms' => 'legal#terms', :as => 'terms'
  get  'privacy' => 'legal#privacy', :as => 'privacy'
  root :to => 'home#index'
end
