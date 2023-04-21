module Api
  module V1
    class UniversitiesController < ApiController
      skip_before_action :doorkeeper_authorize!
      skip_before_action :set_tenant

      def index 
        @universities = University.all
        render json: {
          data: {
            universities: @universities
          },
          status: :ok
        }
      end

      def create
        @university = University.new(organization_params)

        if @university.save
          doorkeeper_application = Doorkeeper::Application.first
          render json: {
            message: "University has been created",
            status: :created,
            data: {
              university: @university,
              doorkeeper_application: {
                name: doorkeeper_application.name,
                client_id: doorkeeper_application.uid,
                client_secret: doorkeeper_application.client_secret
              }
            }
          }
        else
          render json: {
            message: @university.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def get_authorization_details
        current_tenant = Apartment::Tenant.current
        Apartment::Tenant.switch!(params[:id])
        doorkeeper_client = Doorkeeper::Application.first
        Apartment::Tenant.switch!(current_tenant)
        render json: {
          doorkeeper: {
            name: doorkeeper_client.name,
            client_id: doorkeeper_client.uid,
            client_secret: doorkeeper_client.secret
          },status: :ok
        }
      end

      private

      def university_params
        params.require(:university).permit(:name, :subdomain, :established_year, :city, :state, :country)
      end
    end
  end
end

