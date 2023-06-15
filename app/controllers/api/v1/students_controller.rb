module Api
  module V1
    class StudentsController < ApiController

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

      def fetch_marks
        student = Student.find_by(enrollment_number: params[:id])

        
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