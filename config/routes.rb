Rails.application.routes.draw do
  # Root route to the home index page
  root "home#index"

  # Devise user authentication routes
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Home controller custom routes
  get 'home/howitworks'
  get 'home/senior_dashboard'
  get 'home/volunteer_dashboard'
  get 'home/admin_dashboard'
  get 'home/volunteer_approval'
  # Route to show the approval information page
get 'volunteer_approval', to: 'home#volunteer_approval'

  patch 'home/approve_volunteer/:id', to: 'home#approve_volunteer', as: 'approve_volunteer'
  delete 'home/destroy_volunteer/:id', to: 'home#destroy_volunteer', as: 'destroy_volunteer'
    
  
  
post 'home/submit_documents', to: 'home#submit_documents', as: 'submit_documents_home'
post 'tasks/:id/complete_with_comment', to: 'tasks#complete_with_comment', as: 'complete_task_with_comment'


  # Task routes with accept member action
  resources :tasks , except: [:edit] do
    member do
      patch :accept
      post 'mark_complete'
      post :complete_with_comment, to: 'tasks#complete_with_comment'
      patch :release
     patch :rate
    end
    collection do
      get :pending     # Route for pending tasks
      get :my_tasks    # Route for accepted tasks
    end
  end

 



  get 'pending', to: 'tasks#pending'  # Route to view pending tasks
      get 'my_tasks', to: 'tasks#my_tasks'     
  # Admin-specific routes (could be namespaced for clarity)
  # namespace :admin do
  #   resources :users, only: [:index, :update, :destroy] do
  #     member do
  #       patch :approve
  #     end
  #   end
  # end

  # Health check for uptime monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Progressive Web App (PWA) routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end