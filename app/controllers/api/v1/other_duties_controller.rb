module Api
  module V1
    class OtherDutiesController < ApiController

      before_action :set_other_duty, only: [:update, :destroy]

      def index
        @other_duties = OtherDuty.where(other_duty_params)

        other_duties = @other_duties&.map do |duty|
          duty.attributes.merge(
            {
              user_name: duty.user.name,
              designation: duty.user.designation,
              course_name: duty.user.course.name
            }
          )
        end
        
        render json: {
          message: "These are the other duties",
          data: {
            other_duties: other_duties
          },status: :ok
        }
      end

      def create
        @other_duty = OtherDuty.new(other_duty_params)
        @other_duty.branch = @other_duty.user.branch

        if @other_duty.save
          render json: {
            message: "Duty successfully assigned!",
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

      def update

        if @other_duty.update(other_duty_params)
          render json: {
            message: "Successfully updated!",
            data: {
              other_duty: @other_duty
            }, status: :ok
          }
        else
          render json: {
            message: @other_duty.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def fetch_details
        @user = User.find_by_id(params[:id])
        @other_duty = OtherDuty.find_by(other_duty_params.merge(user_id: params[:id]))

        other_duty = @other_duty.attributes.merge({
          user_name: @user.name,
          designation: @user.designation,
          course_name: @user.course.name
        }) if @other_duty.present?

        if other_duty
          render json: {
            message: "Details found",
            data: {
              other_duty: other_duty
            }, status: :ok
          }
        else
          if @user
            render json: {
              message: "No Other Duty data found for #{@user.name}, create one!",
              status: :unprocessable_entity
            } 
          end
        end
      end

      def destroy
        if @other_duty.destroy
          render json: {
            message: "Successfully deleted!",
            status: :ok
          }
        else
          render json: {
            message: @other_duty.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def set_other_duty
        @other_duty = OtherDuty.find_by_id(params[:id])
      end

      def other_duty_params
        params.require(:other_duty).permit(:user_id, :assigned_duties, :examination_name, :academic_year, :course_id, :branch_id, :time, :other_duty_type)
      end
    end
  end
end