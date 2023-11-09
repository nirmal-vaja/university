class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError do |exception|
    policy = exception.policy
    policy_name = exception.policy.class.to_s.underscore

    error_key = if policy.respond_to?(:policy_error_key) && policy.policy_error_key
      policy.policy_error_message
    else
      exception.query
    end


    render json: {
      message: t("#{policy_name}.#{error_key}", scope: "pundit", default: :default),
      status: :unprocessable_entity
    }
  end
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tenant

  protect_from_forgery with: :null_session
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :date_of_joining, :phone_number, :admin])
  end

  private

  def set_tenant
    subdomain = params[:subdomain]
    if params[:admin].present?
      Apartment::Tenant.switch!
    else
      subdomain.present? ? Apartment::Tenant.switch!(subdomain) : Apartment::Tenant.switch!
    end
  end
end
