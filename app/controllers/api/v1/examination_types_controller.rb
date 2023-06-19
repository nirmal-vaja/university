module Api
  module V1
    class ExaminationTypesController < ApiController
      before_action :find_examination_type, only: [:update, :destroy]

      def index
        @examination_types = ExaminationType.all

        if @examination_types
          render json: {
            message: "Types found",
            data: {
              examination_types: @examination_types
            },status: :ok
          }
        else
          render json: {
            message: "Name not found",
            status: :not_found
          }
        end
      end

      def fetch_maximum_marks
        @examination_type = ExaminationType.find_by_name(params[:id])

        if @examination_type
          render json: {
            message: "Type found",
            status: :ok,
            data: {
              maximum_marks: @examination_type.maximum_marks
            }
          }
        else
          render json: {
            message: "Type not found",
            status: :not_found
          }
        end
      end

      def create
        @examination_type = ExaminationType.new(examination_type_params)

        if @examination_type.save
          render json: {
            message: "Created",
            data: {
              examination_type: @examination_type
            },status: :created
          }
        else
          render json: {
            message: @examination_type.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @examination_type.update(examination_type_params)
          render json: {
            message: "Updated",
            data: {
              examination_type: @examination_type
            },status: :ok
          }
        else
          render json: {
            message: @examination_type.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @examination_type.destroy
          render json: {
            message: "Deleted",
            status: :ok
          }
        else
          render json: {
            message: @examination_type.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def find_examination_type
        @examination_type = ExaminationType.find_by_id(params[:id])
      end

      def examination_type_params
        params.require(:examination_type).permit(:name, :maximum_marks)
      end
    end
  end
end