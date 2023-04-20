class University < ApplicationRecord
  validates_presence_of :name, :subdomain
  after_create :create_tenant

  private

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end
end
