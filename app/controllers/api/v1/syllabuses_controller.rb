module Api
  module V1
    class SyllabusesController < ApplicationController

      def index
        @syllabuses = Syllabus.where(syllabus_params)

        if @syllabuses
          render json: {
            message: "Details found",
            data: {
              syllabuses: @syllabuses
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def create
        @syllabus = Syllabus.new(syllabus_params)

        if @syllabus.save && @syllabus.syllabus_pdf.attached?
          render json: {
            message: "Syllabus has been uploaded",
            data: {
              syllabus: @syllabus
            }, status: :ok
          }
        else
          render json: {
            message: @syllabus.errors.full_messages * ', ',
            status: :unprocessable_entity
          }
        end
      end

      def show
        @syllabus = Syllabus.find_by_id(params[:id])
        
        if @syllabus
          render json: {
            message: "Details found",
            data: {
              syllabus: @syllabus
            }, status: :ok
          }
        else
          render json: {
            message: "Details not found",
            status: :not_found
          }
        end
      end

      def update
        @syllabus = Syllabus.find_by_id(params[:id])

        if @syllabus.update(syllabus_params)
          render json: {
            message: "Syllabus has been updated",
            data: {
              syllabus: @syllabus
            }, status: :ok
          }
        else
          render json: {
            message: @syllabus.errors.full_messages * ', ',
            status: :unprocessable_entity
          }
        end
      end

      private

      def syllabus_params
        params.require(:syllabus).permit(:course_id, :branch_id, :semester_id, :subject_id, :syllabus_pdf)
      end
    end
  end
end