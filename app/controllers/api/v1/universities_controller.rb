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

      def get_details
        @university = University.find_by(subdomain: params[:id])

        if @university
          render json: {
            university: @university
          }
        end
      end

      def create
        @university = University.new(university_params)
        @university.subdomain = @university.name.split().reject{|i| i.downcase=="university"}.join("_").downcase

        if @university.save
          current_tenant = Apartment::Tenant.current
          Apartment::Tenant.switch!(@university.subdomain)
          doorkeeper_application = Doorkeeper::Application.first
          user = User.create(
            email: university_params[:admin_email],
            password: university_params[:admin_password],
            status: "true",
            phone_number: "7890098767"
          )

          user.add_role :super_admin
          UserMailer.send_university_registration_mail(user, @university, university_params[:admin_password], university_params[:url]).deliver_now
          Apartment::Tenant.switch!(current_tenant)
          render json: {
            message: "University has been registered",
            status: :created,
            data: {
              university: @university,
              doorkeeper_application: {
                name: doorkeeper_application.name,
                client_id: doorkeeper_application.uid,
                client_secret: doorkeeper_application.secret
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
        university = University.find_by_subdomain(params[:id])
        doorkeeper_client = Doorkeeper::Application.first
        Apartment::Tenant.switch!(current_tenant)
        render json: {
          university: {
            name: university.name
          },
          doorkeeper: {
            name: doorkeeper_client.name,
            client_id: doorkeeper_client.uid,
            client_secret: doorkeeper_client.secret
          },status: :ok
        }
      end

      private

      def university_params
        params.require(:university).permit(:name, :subdomain, :established_year, :city, :state, :country, :admin_email, :admin_password, :examination_controller_email, :assistant_exam_controller_email, :academic_head_email, :hod_email, :url)
      end
    end
  end
end

