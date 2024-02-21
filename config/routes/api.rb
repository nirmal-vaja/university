# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    get "/get_authorization_details", to: "home#get_authorization_details"
    get "/current_user", to: "home#get_current_user"
    get "/universities", to: "home#get_universities"
    post "/check_subdomain", to: "home#check_subdomain"
    get "/find_user", to: "home#find_user"
    resources :roles, only: [:index, :create, :destroy] do
      collection do
        get :fetch_roles
      end
    end

    resources :universities, only: [:index, :create] do
      member do
        get :get_authorization_details
        post :approve_university
        post :reject_university
      end
    end

    resources :blocks do
      member do
        post :assign_students
        get :fetch_rooms_details
        get :fetch_students_details
        put :reassign_block
      end
      
      collection do
        get :fetch_blocks_date_wise
      end
    end

    resources :block_extra_configs

    resources :rooms do
      member do
        post :assign_block
      end
    end

    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
      resources :users, only: [:index] do
        collection do
          get :find_user
          get :faculty_names
          get :faculties_for_other_duties
          get :assigned_role_users
          post :send_otp
        end
        member do
          post :assign_role
          post :deassign_role
        end
      end
    end

    post 'forgot_password', to: 'passwords#forgot_password'
    put 'reset_password', to: 'passwords#reset_password'

    resources :excel_sheets, only: [:index, :create, :update, :destroy]

    #Examination Details

    resources :examination_names, only: [:index, :create, :update, :destroy]
    resources :examination_times, only: [:index, :create, :update, :destroy]
    resources :examination_types, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_maximum_marks
      end
    end

    resources :courses, only: [:index]
    resources :branches, only: [:index]
    resources :semesters, only: [:index]
    resources :subjects, only: [:index] do
      collection do
        get :fetch_subjects
      end
    end
    resources :divisions, only: [:index]

    resources :exam_time_tables, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_dates
        get :fetch_details
        get :fetch_subject_codes
      end

      collection do
        get :get_examination_dates
        get :fetch_subjects
        get :fetch_blocks
        get :fetch_students
      end
    end

    resources :time_table_block_wise_reports, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end

    resources :supervisions, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end
    
    resources :other_duties, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end

    resources :marks_entries, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end
    
    resources :students, only: [:index, :update, :destroy] do
      member do
        get :find_student
        get :fetch_subjects
        put :update_fees
        get :fetch_fee_payment_status
        get :fetch_paid_fee_detail
        post :request_certificate
      end

      collection do
        get :find_student_by_auth_token
        put :update_student_mass_operation
      end

      resources :payments, only: [:create, :index, :show]

      collection do
        post :otp_login
        post :validate_otp
        post 'payments/callback', to: 'payments#callback'
      end
    end

    resources :student_certificates, only: [:index, :update]

    resources :certificates, only: [:index, :create, :update, :destroy]

    resources :syllabuses, only: [:index, :show, :create, :update] do
      member do
        get :fetch_details
      end
    end

    resources :fee_details, only: [:index, :create, :update, :destroy] do
      member do
        get :fetch_details
      end
    end

    resources :student_marks, only: [:index, :create, :update] do
      collection do
        get :eligible_for_publish
        put :unpublish_marks
        get :fetch_student_marks
        put :publish_marks
        put :lock_marks
        put :unlock_marks
        get :fetch_subjects
        get :fetch_status
        get :fetch_publish_status
        get :fetch_type
        get :fetch_marks_through_enrollment_number
      end

      member do
        get :fetch_details
        get :fetch_marks
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