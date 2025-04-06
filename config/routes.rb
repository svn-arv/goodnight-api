Rails.application.routes.draw do
  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Sleep record routes
  post 'clock_in', to: 'sleep_records#clock_in'
  post 'clock_out', to: 'sleep_records#clock_out'

  # Relationship routes
  post 'follow', to: 'relationships#follow'
  post 'unfollow', to: 'relationships#unfollow'
  get 'following_sleep_records', to: 'relationships#following_sleep_records'
end
