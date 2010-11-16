MailCongress::Application.routes.draw do
  scope :constraints => { :protocol => Rails.env == 'production' ? 'https' : 'http' } do
    post 'search' => 'search#show', :as => 'search'
    root  :to => 'home#index'
    post 'letters' => 'letters#create', :as => 'letters'
    post 'letters/preview' => 'letters#show', :as => 'preview_letter'
    post 'payments/new' => 'payments#new', :as => 'new_payment'
    post 'payments' => 'payments#create', :as => 'payments'
    get  'thank-you' => 'thank_you#show', :as => 'thank_you'
  end
end
