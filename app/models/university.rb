class University < ApplicationRecord
  validates_presence_of :name, :subdomain
  after_create :create_tenant
  after_create :create_doorkeeper_application

  private

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end

  def create_doorkeeper_application
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!(subdomain)
    if Doorkeeper::Application.count == 0
      Doorkeeper::Application.create(name:"React client for #{name}", redirect_uri: "", scopes: "", confidential: false)
    else
      Doorkeeper::Application.first
    end
    Apartment::Tenant.switch!(current_tenant)
  end
end
