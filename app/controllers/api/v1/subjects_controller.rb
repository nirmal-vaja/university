module Api
  module V1
    class SubjectsController < ApiController
      def index
        @subjects = Subject.where(semester_id: params[:semester_id])

        render json: {
          data: {
            subjects: @subjects
          }, status: :ok
        }
      end
    end
  end
end