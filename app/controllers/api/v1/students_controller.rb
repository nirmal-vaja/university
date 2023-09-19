module Api
  module V1
    class StudentsController < ApiController

      skip_before_action :doorkeeper_authorize!, only: [:find_student, :fetch_subjects, :otp_login, :validate_otp]
      before_action :find_student_with_mobile_number, only: [:otp_login, :validate_otp]

      def index
        @students = Student.where(student_params)
        students = @students.fees_paid

        if students
          render json: {
            message: "Details found",
            data: {
              students: students
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def find_student_by_auth_token
        @student = Student.find_by(id: doorkeeper_token[:resource_owner_id])
        if @student.present?
          render json: {
            message: "Student Found",
            data: {
              student: @student
            },status: :ok
          }
        else 
          render json: {
            message: "Student not found",
            status: :not_found
          }
        end
      end

      def fetch_paid_fee_detail
        @student = Student.find_by(id: params[:id])
        @fee_detail_ids = @student.payments.paid.pluck(:fee_detail_id)
        @fee_details = FeeDetail.where(id: @fee_detail_ids)

        if @fee_details
          render json: {
            message: "Details found",
            data: {
              fee_details: @fee_details
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def fetch_fee_payment_status
        @student = Student.find_by_id(params[:id])
        @academic_year = params[:academic_year]
        @semester_id = params[:semester_id]
        @fee_detail = FeeDetail.find_by(semester_id: @semester_id, academic_year: @academic_year)
        status = @student.payments.present? && @student.payments.where(status: "paid", academic_year: @academic_year, fee_detail_id: @fee_detail.id).present? || @student.fees_paid

        render json: {
          message: "Status for the payment",
          data: {
            student: @student,
            fee_detail: @fee_detail,
            status: status
          }, status: :ok
        }
      end

      def find_student
        student = Student.find_by_enrollment_number(params[:id])

        if student
          render json: {
            message: "Student found",
            data: {
              student: student
            }, status: :ok
          }
        else
          render json: {
            message: "Student not found",
            status: :not_found
          }
        end
      end

      def fetch_subjects
        student = Student.find_by(enrollment_number: params[:id])

        subjects = student.semester.subjects

        if subjects
          render json: {
            message: "Details found",
            data: {
              subjects: subjects,
              student_id: student.id
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :unprocessable_entity
          }
        end
      end

      def update_fees
        @student = Student.find_by_enrollment_number(params[:id])
        if @student.update(fees_paid: true)
          render json: {
            message: "Fees paid for #{@student.name}",
            data: {
              student: @student
            }, status: :ok
          }
        else
          render json: {
            message: @student.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        @student = Student.find_by_id(params[:id])

        save_student = SaveStudentDetails.new(params[:id], contact_detail_params, address_detail_params, parent_detail_params, guardian_detail_params).call

        if save_student.valid? && @student.update(student_params)
          render_success_response("Successfully Updated!", @student)
        else
          render_error_response(save_student.errors.full_messages.join(', '))
        end
      end

      def otp_login
        if @student.nil?
          render json: {
            message: "No student is registered with the mobile number you provided!",
            status: :unprocessable_entity
          }
        else
          if @student.generate_otp
            StudentMailer.send_otp_mail(@student).deliver_now
            render json: {
              message: "OTP Sent Successfully",
              status: :ok
            }
          end
        end
      end

      def validate_otp
        if @student.nil?
          render json: {
            message: "Entered Mobile Number is incorrect.",
            status: :unprocessable_entity
          }
        else
          if @student.otp === params[:otp] && @student.otp_generated_at >= 5.minutes.ago
            render json: {
              message: "Verified successfully",
              status: :ok
            }
          else
            render json: {
              message: "Invalid OTP, please try again!",
              status: :unprocessable_entity
            }
          end
        end
      end

      def request_certificate
        @student = Student.find_by_id(params[:id])
        if @student
          @student_certificate = @student.student_certificates.new(student_certificate_params)
          if @student_certificate.save
            render json: {
              message: "Certificate has been requested",
              data: {
                student_certificate: @student_certificate
              }, status: :created
            }
          else
            render json: {
              message: @student_certificate.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        end
      end

      private

      def find_student
        @student = Student.find_by_id(params[:id])
      end

      def find_student_with_mobile_number
        @student = ContactDetail.find_by_mobile_number(params[:mobile_number])&.student || ContactDetail.find_by_personal_email_address(params[:mobile_number])&.student || ContactDetail.find_by_university_email_address(params[:mobile_number])&.student
      end

      def render_success_response(message, student)
        render json: {
          message: message,
          data: {
            student: student
          },
          status: :ok
        }
      end
      
      def render_error_response(message)
        render json: {
          message: message,
          status: :unprocessable_entity
        }
      end

      def student_params
        if params["student"].present?
          params.require(:student).permit(:course_id, :branch_id, :semester_id, :name, :enrollment_number, :barcode, :qrcode, :gender, :father_name, :mother_name, :date_of_birth, :birth_place, :religion, :caste, :nationality, :mother_tongue, :marrital_status, :blood_group, :physically_handicapped, certificate_ids: []).to_h
        else 
          {}
        end
      end

      def contact_detail_params
        if params["contact_detail"].present?
          params.require(:contact_detail)&.permit(:mobile_number, :emergency_mobile_number, :residence_phone_number, :personal_email_address, :university_email_address, :fathers_mobile_number, :fathers_personal_email, :mothers_mobile_number, :mothers_personal_email).to_h
        end
      end

      def address_detail_params
        if params["address_detail"].present?
          params.require(:address_detail)&.permit(:current_address_1, :current_address_2, :current_address_area, :current_address_city, :current_address_country, :current_address_pincode, :current_address_state, :permanent_address_1, :permanent_address_2, :permanent_address_area, :permanent_address_city, :permanent_address_country, :permanent_address_pincode, :permanent_address_state).to_h
        end
      end

      def parent_detail_params
        if params["parent_detail"].present?
          params.require(:parent_detail)&.permit(:qualification_of_father, :occupation_of_father, :father_company_name, :father_designation, :father_office_address, :father_annual_income, :father_professional_email, :qualification_of_mother, :occupation_of_mother, :mother_company_name, :mother_designation, :mother_office_address, :mother_annual_income, :mother_professional_email, :date_of_marriage).to_h
        end
      end

      def guardian_detail_params
        if params["guardian_detail"].present?
          params.require(:guardian_detail)&.permit(:name, :relation, :mobile_number, :personal_email, :professional_email, :address_1, :address_2, :area, :country, :state, :city, :pincode).to_h
        end
      end

      def student_certificate_params
        params.require(:student_certificate).permit(:number_of_copy, :amount, :certificate_id, :reason).to_h
      end
    end
  end
end
