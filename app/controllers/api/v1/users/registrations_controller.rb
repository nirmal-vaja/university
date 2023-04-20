module Api
    module V1
      module Users
        class RegistrationsController < ApiController
          skip_before_action :doorkeeper_authorize!, only: %i[create]
          skip_before_action :set_tenant, only: %i[create]
  
          include DoorkeeperRegistrable
  
          def create
            current_tenant = Apartment::Tenant.current
            Apartment::Tenant.switch!(params[:subdomain])
            client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
  
            unless client_app
              return render json: {
                error: I18n.t('doorkeeper.errors.messages.invalid_client')
              }, status: :unauthorized
            end
            allowed_params = user_params.except(:client_id, :subdomain)
            user = User.new(allowed_params)
            user.department = params[:department]
            if user.save
              render json: render_user(user,client_app), status: :created
            else
              render json: { errors: user.errors }, status: :unprocessable_entity
            end
            Apartment::Tenant.switch!(current_tenant)
          end
  
          private 
  
          def user_params
            params.require(:user).permit(:subdomain, :first_name, :last_name, :date_of_joining, :phone_number, :email, :password, :client_id, :designation)
          end
        end
      end
    end
  end