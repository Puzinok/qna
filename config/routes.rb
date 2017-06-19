Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true
  end
end
