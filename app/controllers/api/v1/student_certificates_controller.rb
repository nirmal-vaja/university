module Api
  module V1
    class StudentCertificatesController < ApiController

      def index
        @student_certificates = 
          if params["student_certificate"].present?
            StudentCertificate.where(student_certificate_params)
          else
            StudentCertificate.pending
          end

        if @student_certificates
          render json: {
            message: "Details found",
            data: {
              student_certificates: @student_certificates
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def update
        @student_certificate = StudentCertificate.find_by_id(params[:id])

        if @student_certificate.update(student_certificate_params)
          render json: {
            message: "Request #{@student_certificate.status}",
            data: {
              student_certificate: @student_certificate
            },status: :ok
          }
        else
          render json: {
            message: @student_certificate.errors.full_messages.join(", "),
            status: :unprocessable_entity
          }
        end
      end

      private

      def student_certificate_params
        params.require(:student_certificate).permit(:status, :notes, :student_id)
      end
    end
  end
end