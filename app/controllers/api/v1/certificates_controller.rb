module Api
  module V1
    class CertificatesController < ApiController

      before_action :find_certificate, only: [:update, :destroy]

      def index
        @certificates = Certificate.all

        if @certificates
          render json: {
            message: "Certificates found",
            data: {
              certificates: @certificates
            },status: :ok
          }
        else
          render json: {
            message: "Certificates not found",
            status: :not_found
          }
        end
      end

      def create
        @certificate = Certificate.new(certificate_params)

        if @certificate.save
          render json: {
            message: "Created Successfully",
            data: {
              certificate: @certificate
            }, status: :created
          }
        else
          render json: {
            message: @certificate.errors.full_messages.join(", "),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @certificate
          if @certificate.update(certificate_params)
            render json: {
              message: "Successfully updated",
              status: :ok
            }
          else
            render json: {
              message: @certificate.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: "Certificate not found",
            status: :not_found
          }
        end
      end

      def destroy
        if @certificate
          if @certificate.destroy
            render json: {
              message: "Successfully deleted",
              status: :ok
            }
          else
            render json: {
              message: @certificate.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: "Certificate not found",
            status: :not_found
          }
        end
      end

      private

      def find_certificate
        @certificate = Certificate.find_by_id(params[:id])
      end

      def certificate_params
        params.require(:certificate).permit(:name, :amount).to_h
      end
    end
  end
end