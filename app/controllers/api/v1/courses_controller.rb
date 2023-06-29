module Api
  module V1
    class CoursesController < ApiController

      skip_before_action :doorkeeper_authorize!

      def index
        @courses = Course.all

        render json: {
          data: {
            courses: @courses
          }, status: :ok
        }
      end
    end
  end
end