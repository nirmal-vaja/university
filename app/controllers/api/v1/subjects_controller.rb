module Api
  module V1
    class SubjectsController < ApiController
      def index
        @subjects = Subject.where(subject_params)

        render json: {
          data: {
            subjects: @subjects
          }, status: :ok
        }
      end

      private

      def subject_params
        params.require(:subject).permit(:course_id, :branch_id, :semester_id, ids: []).to_h
      end
    end
  end
end