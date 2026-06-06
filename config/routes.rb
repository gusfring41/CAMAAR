Rails.application.routes.draw do
  resources :resposta_elems
  resources :resposta_forms
  resources :campo_forms
  resources :elemento_forms
  resources :formularios
  resources :campos
  resources :elementos
  resources :templates
  resources :docentes
  resources :discentes
  resources :usuarios
  resources :turmas
  resources :disciplinas
  resources :cursos
  resources :departamentos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "admin", to: "admin#index", as: :admin
  post "admin/importar_sigaa", to: "admin#importar_sigaa", as: :importar_sigaa
  post "admin/atualizar_sigaa", to: "admin#atualizar_sigaa", as: :atualizar_sigaa

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
