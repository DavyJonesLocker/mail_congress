MailCongress::Application.routes.draw do
  get  'follow_ups/:id', :to => 'follow_ups#show', :as => 'follow_up'

  resources :campaigns
  get  'dashboard', :to => 'advocacy_groups#show', :as => 'dashboard'
  get  'sign_up',  :to => 'advocacy_groups#new', :as => 'sign_up'
  post 'sign_up',  :to => 'advocacy_groups#create'

  devise_for :advocacy_groups, :controllers => { :sessions => 'sessions' }, :skip => [:sessions] do
    get  'sign_in',  :to => 'sessions#new', :as => 'new_advocacy_group_session'
    post 'sign_in',  :to => 'sessions#create', :as => 'advocacy_group_session'
    get  'sign_out', :to => 'sessions#destroy', :as => 'destroy_advocacy_group_session'
  end
  get  'c/:campaign_id' => 'home#index', :as => 'campaign_permalink'
  post 'search' => 'search#show', :as => 'search'
  post 'letters/preview' => 'letters#show', :as => 'preview_letter'

  # Paypal routes
  get  'payments/cancel/:redis_key' => 'payments#destroy', :as => 'cancel_payment'
  get  'payments/complete/:redis_key' => 'payments#complete', :as => 'complete_payment'

  post 'payments/new' => 'payments#new', :as => 'new_payment'
  post 'payments' => 'payments#create', :as => 'payments'

  post 'feedback' => 'feedback#create', :as => 'feedback'
  get  'feedback' => 'feedback#new', :as => 'new_feedback'
  get  'thank-you' => 'thank_you#show', :as => 'thank_you'
  get  'terms' => 'legal#terms', :as => 'terms'
  get  'privacy' => 'legal#privacy', :as => 'privacy'
  root :to => 'home#index'
end
