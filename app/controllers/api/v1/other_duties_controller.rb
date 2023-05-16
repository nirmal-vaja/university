module Api
  module V1
    class OtherDutiesController < ApiController
      def index
        @other_duties = OtherDuty.where(academic_year: params[:academic_year]).or(
          OtherDuty.where(examination_name: params[:examination_name])
        )
        
        render json: {
          message: "These are the other duties",
          data: {
            other_duties: @other_duties
          },status: :ok
        }
      end

      def create
        @other_duty = OtherDuty.new(other_duty_params)

        binding.pry
        if @other_duty.save
          render json: {
            message: "Data saved.",
            data: {
              other_duty: @other_duty
            }, status: :created
          }
        else
          render json: {
            message: @other_duty.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def other_duty_params
        params.require(:other_duty).permit(:user_id, :assigned_duties, :examination_name, :academic_year)
      end
    end
  end
end