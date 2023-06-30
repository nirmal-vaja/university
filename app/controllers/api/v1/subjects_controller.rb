module Api
  module V1
    class SubjectsController < ApiController

      skip_before_action :doorkeeper_authorize!
    
      def index
        params =
          if subject_params["id"].present?
            params = subject_params
            params["id"] = JSON.parse(subject_params["id"])
            params
          else
            subject_params
          end
        @subjects = Subject.where(params)

        @subjects = @subjects.map do |subject|
          subject.attributes.merge({
            branch_code: subject.semester.branch.code,
            semester_name: subject.semester.name
          })
        end

        render json: {
          data: {
            subjects: @subjects
          }, status: :ok
        }
      end

      private

      def subject_params
        params.require(:subject).permit(:course_id, :branch_id, :semester_id, :id).to_h
      end
    end
  end
end