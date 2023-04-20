class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tenant

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :date_of_joining, :phone_number, :admin])
  end

  private

  def set_tenant
    subdomain = params[:subdomain]

    subdomain.present? ? Apartment::Tenant.switch!(subdomain) : Apartment::Tenant.switch!
  end
end
