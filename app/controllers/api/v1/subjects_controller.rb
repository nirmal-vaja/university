module Api
  module V1
    class SubjectsController < ApiController
      def index
        @subjects = Subject.where(semester_id: params[:semester_id]) if params[:semester_id]
        @subjects = Subject.where(course_id: params[:course_id]) if params[:course_id]
        @subjects = Subject.where(branch_id: params[:branch_id]) if params[:branch_id]

        render json: {
          data: {
            subjects: @subjects
          }, status: :ok
        }
      end
    end
  end
end