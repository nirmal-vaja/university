module Api
  module V1
    class SubjectsController < ApiController

      skip_before_action :doorkeeper_authorize!
      before_action :set_subject, only: %i[fetch_exam_time_table_details]
    
      def index
        params =
          if subject_params.present? && subject_params["id"].present?
            params = subject_params
            params["id"] = JSON.parse(subject_params["id"])
            params
          else
            subject_params
          end
        @subjects = Subject.where(params)
        
        if @subjects.present?
          @subjects = @subjects.map do |subject|
            subject.attributes.merge({
              is_exam_time_table_created: subject.exam_time_tables.where(time_table_params).any?,
              exam_time_table: subject.exam_time_tables.find_by(time_table_params)
            })
          end
          render json: {
            message: "Details found",
            data: {
              subjects: @subjects
            }, status: :ok
          }
        else
          render json: {
            message: "Subjects not found",
            status: :not_found
          }
        end
      end

      def fetch_subjects
        i = ExaminationType.find_by_name("Internal")&.maximum_marks
        v = ExaminationType.find_by_name("Viva")&.maximum_marks
        e = ExaminationType.find_by_name("External")&.maximum_marks
        m = ExaminationType.find_by_name("Mid")&.maximum_marks

        @subjects = Subject.where(subject_params_for_syllabus)

        @subjects = @subjects&.map do |subject|
          subject.attributes.merge({
            branch_code: subject.semester.branch.code,
            semester_name: subject.semester.name,
            e: e,
            i: i,
            v: v,
            m: m,
          })
        end
        
        if @subjects
          render json: {
            message: "Details found",
            data: {
              subjects: @subjects
            }, status: :ok
          }
        else
          render json: {
            message: "Subjects not found",
            status: :not_found
          }
        end
      end

      private

      def subject_params
        params.require(:subject).permit(:course_id, :branch_id, :semester_id, :id).to_h
      end

      def time_table_params
        params.require(:exam_time_table).permit(:name, :semester_id, :subject_id, :date, :time, :course_id, :branch_id, :academic_year, :day, :time_table_type)
      end

      def subject_params_for_syllabus
        params.require(:subject).permit(:course_id, :branch_id, :semester_id, :id, :code, :name).to_h
      end
    end
  end
end