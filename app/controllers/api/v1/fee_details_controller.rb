module Api
  module V1
    class FeeDetailsController < ApplicationController

      before_action :set_fee_detail, only: [:update, :destroy]

      def index
        @fee_details = FeeDetails.where(fee_detail_params)

        if @fee_details
          render json: {
            message: "Details found",
            data: {
              fee_details: @fee_details
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
        @fee_detail = FeeDetail.new(fee_detail_params)

        if @fee_detail.save
          render json: {
            message: "Fee Details saved.",
            data: {
              fee_detail: @fee_detail
            }, status: :ok
          }
        else
          render json: {
            message: @fee_detail.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def fetch_details
        @fee_detail = FeeDetail.find_by(fee_detail_params)
        semester = Semester.find_by_id(params[:id])

        fee_detail = @fee_detail.attributes.merge({
          semester_name: semester.name
        }) if @fee_detail.present?

        if fee_detail
          render json: {
            message: "Details found",
            data: {
              fee_detail: fee_detail
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
        if @fee_detail.update(fee_detail_params)
          render json: {
            message: "Successfully updated!",
            data: {
              fee_detail: @fee_detail
            }, status: :ok
          }
        else
          render json: {
            message: @fee_detail.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @fee_detail.destroy
          render json: {
            message: "Sucessfully deleted!",
            status: :ok
          }
        else
          render json: {
            message: @fee_detail.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def set_fee_detail
        @fee_detail = FeeDetail.find_by_id(params[:id])
      end

      def fee_detail_params
        params.require(:fee_detail).permit(:amount, :course_id, :branch_id, :semester_id, :academic_year).to_h
      end
    end
  end
end
