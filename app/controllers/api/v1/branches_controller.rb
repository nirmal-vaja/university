module Api
  module V1
    class BranchesController < ApiController

      skip_before_action :doorkeeper_authorize!

      def index
        @branches = Branch.where(course_id: params[:course_id])

        render json: {
          data: {
            branches: @branches
          }, status: :ok
        }
      end
    end
  end
end