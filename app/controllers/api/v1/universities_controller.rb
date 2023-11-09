module Api
  module V1
    class UniversitiesController < ApiController
      skip_before_action :doorkeeper_authorize!, only: [:create, :get_details, :get_authorization_details, :approve_university, :reject_university]
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

      def approve_university
        @university = University.find_by_id(params[:id])
        if @university.update(status: :accepted)
          current_tenant = Apartment::Tenant.current
          Apartment::Tenant.switch!(@university.subdomain)
          @user = User.find_by(email: @university.admin_email)
          token = @user.send(:set_reset_password_token)
          UserMailer.send_university_registration_mail(@university.admin_email, @university, university_params[:url], token).deliver_now
          render json: {
            message: "University accepted",
            accepted_universities: University.accepted,
            rejected_universities: University.rejected,
            pending_universities: University.pending,
            status: :ok
          }
        else
          render json: {
            message: @university.errors.full_messages.join(', '),
            status: :ok
          }
        end
      end

      def reject_university
        @university = University.find_by_id(params[:id])
        if @university.update(status: :rejected)
          render json: {
            message: "University rejected",
            universities: University.pending,
            status: :ok
          }
        else
          render json: {
            message: @university.errors.full_messages.join(', '),
            status: :ok
          }
        end
      end

      def create
        @university = University.new(university_params)
        @university.subdomain = @university.name.split().reject{|i| i.downcase=="university"}.join("_").downcase

        if @university.save
          render json: {
            message: "University has been registered, please wait for the approval!",
            status: :created,
            data: {
              university: @university
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
        @university = University.find_by_subdomain(params[:id])
        
        if @university && @university.status == "accepted"
          Apartment::Tenant.switch!(params[:id])
          doorkeeper_client = Doorkeeper::Application.first
          Apartment::Tenant.switch!(current_tenant)
          render json: {
            university: {
              name: @university.name,
              status: "accepted"
            },
            doorkeeper: {
              name: doorkeeper_client.name,
              client_id: doorkeeper_client.uid,
              client_secret: doorkeeper_client.secret
            },status: :ok
          }
        else
          render json: {
            message: "Couldn't find the University with provided subdomain or if you have already registered please wait for the approval by the administrator.",
            university: {status: @university&.status},
            status: :ok
          }
        end
      end

      private

      def university_params
        params.require(:university).permit(:name, :subdomain, :established_year, :city, :state, :country, :admin_email, :admin_password, :examination_controller_email, :assistant_exam_controller_email, :academic_head_email, :hod_email, :url)
      end
    end
  end
end

