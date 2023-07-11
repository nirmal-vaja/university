module Api
  module V1
    class ExaminationTimesController < ApiController

      skip_before_action :doorkeeper_authorize!
      before_action :find_examination_time, only: [:update, :destroy]

      def index
        @examination_times = ExaminationTime.all

        if @examination_times
          render json: {
            message: "Times found",
            data: {
              examination_times: @examination_times
            }, status: :ok
          }
        else
          render json: {
            message: "No data found",
            status: :unprocessable_entity
          }
        end
      end

      def create
        @examination_time = ExaminationTime.new(examination_time_params)

        if @examination_time.save
          render json: {
            message: "Created Successfully!",
            data: {
              examination_time: @examination_time
            }, status: :created 
          }
        else
          render json: {
            message: @examination_time.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @examination_time.update(examination_time_params)
          render json:{
            message: "Successfully Updated!",
            data: {
              examination_time: @examination_time
            }, status: :ok
          }
        else
          render json: {
            message: @examination_time.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @examination_time.destroy
          render json: {
            message: "Successfully Deleted!",
            status: :ok
          }
        else
          render json: {
            message: @examination_time.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def find_examination_time
        @examination_time = ExaminationTime.find_by_id(params[:id])
      end

      def examination_time_params
        params.require(:examination_time).permit(:name).to_h
      end

    end
  end
end