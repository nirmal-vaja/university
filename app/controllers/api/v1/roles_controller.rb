module Api
  module V1
    class RolesController < ApiController
      def create
        @role = Role.new(role_params)
        if @role.save
          render json: {
            message: "Role has been created",
            data: {
              role: @role
            }, status: :created
          }
        else
          render json: {
            message: @role.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        @role = Role.find_by_id(params[:id])

        if @role.destroy
          render json: {
            message: "Role has been deleted",
            status: :ok
          }
        else 
          render json: {
            message: @role.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def role_params
        params.require(:role).permit(:name)
      end
    end
  end
end