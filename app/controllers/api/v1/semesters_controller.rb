module Api
  module V1
    class SemestersController < ApiController
      def index
        @semesters = Semester.where(branch_id: params[:branch_id])

        render json: {
          data: {
            semesters: @semesters
          }, status: :ok
        }
      end
    end
  end
end