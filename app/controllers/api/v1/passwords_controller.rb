module Api
  module V1
    class PasswordsController < ApiController
      skip_before_action :doorkeeper_authorize!

      def forgot_password
        user = User.find_by_email(params[:email])
        url = params[:url]
        binding.pry
        if user
          token = user.send_reset_password_instructions(url: url)
          render json: {
            message: "Password reset instructions sent.",
            data: {
              token: token
            },
            status: :ok
          }
        else
          render json: {
            message: "User not found",
            status: :not_found
          }
        end
      end

      def reset_password
        user = User.reset_password_by_token(reset_password_params)
        if user.errors.empty?
          render json: {
            message: "Password reset successfully.",
            status: :ok
          }
        else
          render json: {
            message: user.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def reset_password_params
        params.permit(:reset_password_token, :password, :password_confirmation)
      end
    end
  end
end