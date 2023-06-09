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

      def update
        begin
          StudentMark.transaction do
            student_mark_params_for_create.each do |student_mark|
              student_mark = StudentMark.find(student_mark[:id])
              student_mark.update!(
                marks: student_mark[:marks]
              )
            end
            @student_marks = StudentMark.where(id: student_mark_params_for_create[:student_marks].pluck(:id))
          end
        rescue ActiveRecord::RecordNotFound
          @student_marks = {
            error: {
              status: 404,
              message: "Details not found"
            }
          }
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
            }, status: :ok
          }
        end
      end

      def fetch_subjects
        @student_marks = StudentMark.where(student_mark_params)

        if @student_marks
          render json: {
            message: "Details found",
            data: {
              subject_ids: @student_marks.pluck(:subject_id).uniq
            },status: :ok
          }
        else
          render json: {
            message: "You haven't entered any marks yet!",
            status: :unprocessable_entity
          }
        end
      end

      def fetch_status
        @student_marks = StudentMark.where(student_mark_params)

        if @student_marks
          render json: {
            message: "Details found",
            data: {
              locked: @student_marks.pluck(:lock_marks).uniq.first
            },
            status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def fetch_details
        @student_mark = StudentMark.find_by(student_mark_params)

        if @student_mark.present?
          render json: {
            message: "Details found",
            data: {
              student_mark: @student_mark
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :unprocessable_entity
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
        params.permit(student_marks: [:id, :examination_name, :examination_type, :academic_year, :course_id, :branch_id, :semester_id, :division_id, :subject_id, :student_id, :marks]).require(:student_marks)
      end

      def student_mark_params
        params.require(:student_mark).permit(:examination_name, :examination_type, :academic_year, :course_id, :branch_id, :semester_id, :division_id, :subject_id, :marks, :student_id).to_h
      end
    end
  end
end