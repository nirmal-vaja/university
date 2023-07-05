module Api
  module V1
    class PasswordsController < ApiController

      def forgot_password
        user = User.find_by_email(params[:email])
        if user
          user.send_reset_password_instruction
          render json: {
            message: "Password reset instructions sent.",
            status: :ok
          }
        else
          render json: {
            message: "User not found",
            status: :not_found
          }
        end
      end

      def reset_passsword
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