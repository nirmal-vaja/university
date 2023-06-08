# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
      resources :users, only: [:index] do
        collection do
          get :find_user
          get :faculty_names
          get :faculties_for_other_duties
          get :assigned_role_users
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

    resources :other_duties, only: [:index, :create, :update] do
      member do
        get :fetch_details
      end
    end

    resources :exam_time_tables, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_dates
        get :fetch_details
        get :fetch_subject_codes
      end

      collection do
        get :get_examination_dates
      end
    end


    resources :courses, only: [:index]
    resources :branches, only: [:index]
    resources :semesters, only: [:index]
    resources :subjects, only: [:index]
    resources :divisions, only: [:index]
    resources :students, only: [:index] do
      member do
        put :update_fees
      end
    end


    resources :supervisions, only: [:index, :create, :update] do
      member do
        get :fetch_details
      end
    end

    resources :time_table_block_wise_reports, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end
    resources :excel_sheets, only: [:index, :create, :update, :destroy]
    resources :marks_entries, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end

    resources :examination_names, only: [:index, :create, :update, :destroy]
    resources :examination_types, only: [:index, :create, :update, :destroy]
    resources :student_marks, only: [:index, :create] do
      collection do
        put :lock_marks
        put :unlock_marks
      end
    end
  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end
end