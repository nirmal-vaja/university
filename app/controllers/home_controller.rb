class HomeController < ApplicationController
  def index
  end

  def get_authorization_details
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!
    doorkeeper_client = Doorkeeper::Application.first
    Apartment::Tenant.switch!(current_tenant)

    render json: {
      doorkeeper: {
        name: doorkeeper_client.name,
        client_id: doorkeeper_client.uid,
        client_secret: doorkeeper_client.secret
      }, status: :ok
    }
  end
end
