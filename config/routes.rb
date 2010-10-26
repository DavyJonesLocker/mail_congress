MailCongress::Application.routes.draw do
  post 'search' => 'search#show', :as => 'search'
  root :to => 'home#index'
  post 'letters' => 'letters#create', :as => 'letters'
end
