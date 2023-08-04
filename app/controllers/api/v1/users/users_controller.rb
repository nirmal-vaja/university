module Api
  module V1
    module Users
      class UsersController < ApiController
        skip_before_action :doorkeeper_authorize!, only: [:send_otp]

        def index
          @user = User.where(show: true)
        end

        def find_user
          found_user = User.find_by(id: doorkeeper_token[:resource_owner_id])

          if found_user.show

          end

          if found_user.present?
            if found_user.show
              render json: {
                message: "User found",
                user: found_user,
                roles: found_user.roles.pluck(:name),
                configurations: found_user.configs,
                status: :ok
              }
            else
              role = found_user.roles.where.not(name: "faculty").first
              user = User.where(
                course_id: found_user.course.id,
                show: true
              ).with_role(role&.name).last
              if user
                render json: {
                  message: "User found",
                  user: user,
                  roles: user.roles.pluck(:name),
                  configurations: user.configs,
                  status: :ok
                }
              else
                render json: {
                  message: "User not found",
                  status: :not_found
                }
              end
            end
          else
            render json: {
              message: "Invalid email address",
              status: :not_found
            }
          end
        end

        # Fetching Faculty Names in the assign roles page
        def faculty_names

          @users = User.where(show: true).with_role(:faculty)
          @users = @users.where(user_params) if params[:user].present?

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
          role_names = Role.all.pluck(:name).reject{ |x| x == "super_admin" || x == "faculty" || x == "Marks Entry" }
          @users = []
          role_names.each do |name|
            if params[:user].present? && user_params[:course_id].present?
              @users << User.where(course_id: user_params[:course_id], show: true).with_any_role(name)
            end
          end
          users = @users&.flatten.map do |user|
            user.attributes.merge(
              {
                role_names: user.roles_name.reject{ |x| x == "super_admin" || x == "faculty" || x == "Marks Entry" }.join(', ')
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
          @users = User.where(show: true).with_role(:faculty)
          @users = @users.where(user_params).reject{ |user| user.supervisions.exists? }

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
          @role = add_role(params[:id], user_params[:role_name])
          @user = User.find_by_id(params[:id])
          subdomain = params[:subdomain]
          role_email = @user.course.name.delete(".").downcase + "_" + @role.abbr + "@" + subdomain.tr("_", "") + ".com"
          @user.send_role_assigned_notification(role_name: user_params[:role_name], url: params[:url], role_email: role_email)
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
          @user = User.find_by_id(params[:id])
          if @user
            remove_role(params[:id], user_params[:role_name])
            role_name = user_params[:role_name]
            render json: {
              message: "Role Deassigned",
              data: {
                user: @user,
                role: role_name
              }, status: :ok
            }
          else
            render json: {
              message: "User not found",
              status: :unprocessable_entity
            }
          end
          
        end

        def send_otp
          user = User.find_by_email(params[:email])
          
          if user.present?
            role = user.roles.where.not(name: "faculty").first
            if role.present?
              @user = User.where(
                course_id: user.course.id,
                show: true
              ).with_role(role.name).last
              if @user.present?
                @user = @user.generate_otp
                @user.send_otp_mail
    
                render json: {
                  message: "OTP has been sent to your email, please check your mail and come back!",
                  otp: @user.otp,
                  status: :ok
                }
              else
                render json:{
                  message: "No faculties has been assigned as #{role.name}",
                  status: :unprocessable_entity
                }
              end
            else
              render json: {
                message: "You haven't been assigned any role",
                status: :unprocessable_entity
              }
            end
          else
            render json: {
              message: "Invalid Email Address",
              status: :unprocessable_entity
            }
          end
        end

        private

        def give_user_details(user)
          role = user.roles.where.not(name: "faculty").first
          User.where(
            course_id: user.course.id,
            show: true
          ).with_role(role.name).last
        end

        def remove_role(user_id, role_name)
          @user = User.find_by_id(user_id)
          @user.remove_role_w ithout_deletion(role_name) if @user.has_role? role_name
        end

        def add_role(user_id, role_name)
          @user = User.find_by_id(user_id)
          @user.add_role(role_name)
        end

        def user_params
          params.require(:user).permit(:role_name, :course_id, :branch_id, :user_type)
        end
      end
    end
  end
end