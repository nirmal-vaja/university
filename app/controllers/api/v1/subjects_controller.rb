module Api
  module V1
    class SubjectsController < ApiController
      def index
        @subjects = Subject.where(subject_id: params[:subject_id])

        render json: {
          data: {
            subjects: @subjects
          }, status: :ok
        }
      end
    end
  end
end