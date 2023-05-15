module Api
  module V1
    class SupervisionsController < ApiController

      def index
        @supervisions = Supervision.where(list_type: params[:type]).or(
          Supervision.where(academic_year: params[:academic_year])
        ).or(
          Supervision.where(examination_name: params[:examination_name])
        )

        supervisions = @supervisions.map do |supervision|
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

      private

      def supervision_params
        params.require(:supervision).permit(:examination_name, :academic_year, :list_type, :user_id )
      end
    end
  end
end