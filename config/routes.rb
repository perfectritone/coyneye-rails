Rails.application.routes.draw do
  root to: 'static_pages#index'

  post 'sleepiness', to: 'sleepinesses#flip'
  post 'staggered_thresholds', to: 'thresholds#staggered', as: 'staggered_threshold'
  post 'thresholds/max', to: 'thresholds#max', as: 'max_threshold'
  post 'thresholds/min', to: 'thresholds#min', as: 'min_threshold'
  delete 'prices', to: 'prices#delete_all'
end
