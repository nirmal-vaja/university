# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
      resources :users, only: [:index] do
        collection do
          get :find_user
          get :faculty_names
        end
        member do
          post :assign_role
          post :deassign_role
        end
      end
    end
    resources :roles, only: [:index,:create, :destroy]
    resources :universities, only: [:index, :create] do
      member do
        get :get_authorization_details
      end
    end

    resources :excel_sheets, only: [:index, :create, :update, :destroy]
  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end
end