module Api
  module V1
    class SemestersController < ApiController

      skip_before_action :doorkeeper_authorize!

      def index
        @semesters = Semester.where(branch_id: params[:branch_id])

        if params[:ids].present?
          @semesters = @semesters.where(id: params[:ids].split(","))
        end

        render json: {
          data: {
            semesters: @semesters
          }, status: :ok
        }
      end
    end
  end
end