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

      end
    end
  end
end