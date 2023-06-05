module Api
  module V1
    class DivisionsController < ApiController

      def index
        @divisions = Division.where(division_params)

        if @divisions
          render json: {
            message: "Details found",
            data: {
              divisions: @divisions,
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      private

      def division_params
        params.require(:division).permit(:semester_id, :name)
      end
    end
  end
end