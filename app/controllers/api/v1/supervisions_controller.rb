module Api
  module V1
    class SupervisionsController < ApiController
      before_action :fetch_supervisions, only: [:index]

      def index
        @supervisions = @supervisions.where(list_type: params[:type])

        supervisions = @supervisions&.map do |supervision|
          supervision.attributes.merge({
            faculty_name: supervision.user.name,
            designation: supervision.user.designation,
            department: supervision.user.department
          })
        end

        render json: {
          message: "These are all the supervisions",
          data: {
            supervisions: supervisions
          }, status: :ok
        }
      end

      def create
        @supervision = Supervision.new(supervision_params)
        @supervision.metadata = params["supervision"]["metadata"]
        authorize @supervision
        if @supervision.save
          render json: {
            message: "List has been saved.",
            data: {
              supervision: @supervision
            }, status: :created
          }
        else
          render json: {
            message: @supervision.errors.full_messages,
            status: :unprocessable_entity
          }
        end
      end

      def fetch_details
        user = User.find_by_id(params[:id])
        @supervision = Supervision.find_by(user_id: params[:id])
        supervision = @supervision.attributes.merge(
          {
            user_name: user.name,
            designation: user.designation,
            course_name: user.course.name
          }
        ) if @supervision.present?

        if supervision
          render json: {
            message: "Details found",
            data: {
              supervision: supervision
            }, status: :ok
          }
        else
          render json: {
            message: "No Supervision data found for #{user.name}, create one!",
            status: :unprocessable_entity
          }
        end
      end

      private

      def fetch_supervisions
        @supervisions = Supervision.where(academic_year: params[:academic_year]).or(
          Supervision.where(examination_name: params[:examination_name])
        ).or(
          Supervision.where(course_id: params[:course_id])
        ).or(
          Supervision.where(branch_id: params[:branch_id])
        ).or(
          Supervision.where(semester_id: params[:semester_id])
        )
      end

      def supervision_params
        params.require(:supervision).permit(:examination_name, :academic_year, :metadata, :list_type, :user_id, :no_of_supervisions, :course_id, :branch_id, :semester_id).to_h
      end
    end
  end
end