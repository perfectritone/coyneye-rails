Rails.application.routes.draw do
  root to: 'static_pages#index'

  post 'thresholds/max', to: 'thresholds#max', as: 'max_threshold'
  post 'thresholds/min', to: 'thresholds#min', as: 'min_threshold'
end
