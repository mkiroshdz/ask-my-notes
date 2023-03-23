Rails.application.routes.draw do
  resources :books, only: [:show] do
    get 'ask'
  end
end
