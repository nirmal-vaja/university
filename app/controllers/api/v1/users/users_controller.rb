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
          @users = @users.where(user_params)

          users = @users.map do |user|
            user.attributes.merge(
              {
                course_name: user.course&.name,
                branch_name: user.branch&.name
              }
            )
          end

          if users
            render json: {
              message: "Faculty lists",
              data: {
                users: users
              },status: :ok
            }
          else
            render json: {
              message: "No faculty found!",
              status: :unprocessable_entity
            }
          end
        end

        def assigned_role_users
          role_names = Role.all.pluck(:name).reject{ |x| x == "super_admin" || x == "faculty" }
          @users = []
          role_names.each do |name|
            @users << User.with_any_role(name)
          end
          users = @users.flatten.map do |user|
            user.attributes.merge(
              {
                role_names: user.roles_name.reject{ |x| x == "super_admin" || x == "faculty" }.join(', ')
              }
            )
          end

          if users
            render json: {
              message: "Details found",
              data: {
                users: users
              }, status: :ok
            }
          else
            render json: {
              message: "No details found",
              status: :unprocessable_entity
            }
          end
        end

        def faculties_for_other_duties
          @users = User.with_role(:faculty)
          @users = @users.where(user_params).reject{ |user| user.supervisions.exist? }

          users = @users.map do |user|
            user.attributes.merge(
              {
                course_name: user.course&.name,
                branch_name: user.branch&.name
              }
            )
          end

          if users
            render json: {
              message: "Faculty lists",
              data: {
                users: users
              },status: :ok
            }
          else
            render json: {
              message: "No faculty found!",
              status: :unprocessable_entity
            }
          end
        end

        def assign_role
          add_role(params[:id], user_params[:role_name])
          @user = User.find_by_id(params[:id])
          role_name = user_params[:role_name]
          render json: {
            message: "Role assigned",
            data: {
              user: @user,
              role: role_name
            }, status: :ok
          }
        end

        def deassign_role
          remove_role(params[:id], user_params[:role_name])
          @user = User.find_by_id(params[:id])
          role_name = user_params[:role_name]
          render json: {
            message: "Role Deassigned",
            data: {
              user: @user,
              role: role_name
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
          params.require(:user).permit(:role_name, :course_id, :branch_id, :user_type)
        end
      end
    end
  end
end