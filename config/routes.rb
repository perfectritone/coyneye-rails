Rails.application.routes.draw do
  root to: 'static_pages#index'
  post 'increase_level', to: 'levels#increase'
end
