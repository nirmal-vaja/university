module Api
  module V1
    class ExaminationNamesController < ApiController
      before_action :find_examination_name, only: [:update, :destroy]

      def index
        @examination_names = ExaminationName.all

        if @examination_names
          render json: {
            message: "Names found",
            data: {
              examination_names: @examination_names
            },status: :ok
          }
        else
          render json: {
            message: "Name not found",
            status: :not_found
          }
        end
      end

      def create
        @examination_name = ExaminationName.new(examination_name_params)

        if @examination_name.save
          render json: {
            message: "Created",
            data: {
              examination_name: @examination_name
            },status: :created
          }
        else
          render json: {
            message: @examination_name.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @examination_name.update(examination_name_params)
          render json: {
            message: "Updated",
            data: {
              examination_name: @examination_name
            },status: :ok
          }
        else
          render json: {
            message: @examination_name.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @examination_name.destroy
          render json: {
            message: "Deleted",
            status: :ok
          }
        else
          render json: {
            message: @examination_name.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def find_examination_name
        @examination_name = ExaminationName.find_by_id(params[:id])
      end

      def examination_name_params
        params.require(:examination_name).permit(:name)
      end
    end
  end
end