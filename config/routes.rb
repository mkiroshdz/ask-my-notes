Rails.application.routes.draw do
  resources :books, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :books, only: [] do
        get 'ask'
      end
    end
  end
end
