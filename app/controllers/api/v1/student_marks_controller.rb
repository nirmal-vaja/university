module Api
  module V1
    class StudentMarksController < ApiController

      def index
        @student_marks = StudentMark.where(student_mark_params)

        if @student_marks
          render json: {
            message: "Details found",
            data: {
              student_marks: @student_marks
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :unprocessable_entity
          }
        end
      end

      def create
        begin
          StudentMark.transaction do
            @student_marks = StudentMark.create!(student_mark_params_for_create)
          end
        rescue ActiveRecord::RecordInvalid => exception
          @student_marks = {
            error: {
              status: 422,
              message: exception
            }
          }
        end
        if @student_marks
          render json: {
            data: {
              student_marks: @student_marks
            }, status: :created
          }
        end
      end

      def lock_marks
        @student_marks = StudentMark.where(student_mark_params)
        subject = Subject.find_by_id(student_mark_params[:subject_id])
        if @student_marks.update_all(lock_marks: true)
          render json: {
            message: " Marks has been locked for #{subject.name}",
            data: {
              student_marks: @student_marks
            }, status: :ok
          }

        else
          render json: {
            message: @student_marks.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def unlock_marks
        @student_marks = StudentMark.where(student_mark_params)
        subject = Subject.find_by_id(student_mark_params[:subject_id])
        if @student_marks.update_all(lock_marks: false)
          render json: {
            message: " Marks has been unlocked for #{subject.name}",
            data: {
              student_marks: @student_marks
            }, status: :ok
          }

        else
          render json: {
            message: @student_marks.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def student_mark_params_for_create
        params.permit(student_marks: [:examination_name, :examination_type, :academic_year, :course_id, :branch_id, :semester_id, :division_id, :subject_id, :student_id, :marks]).require(:student_marks)
      end

      def student_mark_params
        params.require(:student_mark).permit(:examination_name, :examination_type, :academic_year, :course_id, :branch_id, :semester_id, :division_id, :subject_id, :marks).to_h
      end
    end
  end
end