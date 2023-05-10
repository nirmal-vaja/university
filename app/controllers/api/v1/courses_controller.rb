module Api
  module V1
    class CoursesController < ApiController

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