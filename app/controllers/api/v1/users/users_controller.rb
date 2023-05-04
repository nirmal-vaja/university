module Api
  module V1
    module Users
      class UsersController < ApiController

        def index
          @user = User.all
        end

        def find_user
          current_user = User.find_by(id: doorkeeper_token[:resource_owner_id])

          render json: {
            user: current_user, 
            roles: current_user.roles.pluck(:name)
          }
        end

        # Fetching Faculty Names in the assign roles page
        def faculty_names
          @users = User.with_role(:faculty)

          render json: {
            message: "Faculty lists",
            data: {
              users: @users
            }
          }
        end

        def assign_role
          add_role(params[:id], user_params[:role_name])
          @user = User.find_by_id(params[:id])

          render json: {
            message: "Role assigned",
            data: {
              user: @user,
              role: @user.roles
            }, status: :ok
          }
        end

        def deassign_role
          remove_role(params[:id], user_params[:role_name])
          @user = User.find_by_id(params[:id])

          render json: {
            message: "Role Deassigned",
            data: {
              user: @user,
              role: @user.roles
            }, status: :ok
          }
        end

        private

        def remove_role(user_id, role_name)
          @user = User.find_by_id(user_id)
          @user.remove_role(role_name) if @user.has_role? role_name
        end

        def add_role(user_id, role_name)
          @user = User.find_by_id(user_id)
          @user.add_role(role_name) unless @user.has_role? role_name
        end

        def user_params
          params.require(:user).permit(:role_name)
        end
      end
    end
  end
end