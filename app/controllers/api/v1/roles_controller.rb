module Api
  module V1
    class RolesController < ApiController

      def index
        @roles = Role.where.not(name: ['super_admin', 'faculty', 'Marks Entry'])

        render json: {
          message: "These are the roles",
          data: {
            role_names: @roles
          }, status: :ok
        }
      end

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

      def fetch_roles
        @course = Course.find_by_id(params[:course_id])
        @remove_role_name = @course.users
                            .joins(:roles)
                            .where(roles: { name: 'faculty' })
                            .where.not(id: User.joins(:roles).group('users.id').having('COUNT(roles.id) = 1').pluck(:id))
                            .flat_map(&:roles)
                            .map(&:name)
                            .uniq
        @remove_role_name = @remove_role_name + ["super_admin", "faculty", "Marks Entry"]

        @roles = Role.where.not(name: @remove_role_name.uniq)

        if @roles
          render json: {
            message: "These are the roles",
            data: {
              roles: @roles
            },
            status: :ok
          }
        else
          render json: {
            message: "No roles found",
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