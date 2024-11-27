require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :proponents do
    collection do
      get :calculate_discount
      get :generate_report
      post :generate_report
      post :save_report_image
    end
    member do
      get :edit_salary
    end
  end
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get 'report/download/:user_id', to: 'report#download', as: 'download_report_user'
  root to: "proponents#index"
end
