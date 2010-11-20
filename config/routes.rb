MailCongress::Application.routes.draw do
  post 'search' => 'search#show', :as => 'search'
  post 'letters/preview' => 'letters#show', :as => 'preview_letter'
  post 'payments/new' => 'payments#new', :as => 'new_payment'
  post 'payments' => 'payments#create', :as => 'payments'
  get  'thank-you' => 'thank_you#show', :as => 'thank_you'
  get  'terms' => 'legal#terms', :as => 'terms'
  get  'privacy' => 'legal#privacy', :as => 'privacy'
  root  :to => 'home#index'
end
