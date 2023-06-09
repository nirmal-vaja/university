module Api
  module V1
    class StudentsController < ApiController

      skip_before_action :doorkeeper_authorize!, only: [:find_student, :fetch_subjects]

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

      private

      def student_params
        params.require(:student).permit(:course_id, :branch_id, :semester_id, :name, :enrollment_number, :barcode, :qrcode).to_h
      end
    end
  end
end