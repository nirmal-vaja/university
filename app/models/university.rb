class University < ApplicationRecord

  attr_accessor :examination_controller_email, :assistant_exam_controller_email, :academic_head_email, :hod_email, :admin_password, :url

  validates_presence_of :name
  after_update :check_status_changed_to_accept

  scope :accepted, -> {where(status: 'accepted')}
  scope :pending, -> {where(status: 'pending')}
  scope :rejected, -> {where(status: 'rejected')}

  enum status: {
    pending: 0,
    rejected: 1,
    accepted: 2
  }

  private

  def check_status_changed_to_accept
    if status == "accepted"
      create_tenant
      create_default_roles
      create_doorkeeper_application
    end
  end

  def create_tenant
    unless Apartment.connection.schema_exists?(subdomain)
      current_tenant = Apartment::Tenant.current
      Apartment::Tenant.create(subdomain)

      Apartment::Tenant.switch!(subdomain)
      user = User.create(
        email: admin_email,
        password: "password",
        status: "true",
        phone_number: "7890098767"
      )
      user.add_role :super_admin
      Apartment::Tenant.switch!(current_tenant)
    end
  end

  def create_default_roles
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!(subdomain)
    Role.find_or_create_by(name: "Examination Controller").tap do |role|
      role.update!(default_email: self.examination_controller_email, abbr: "coe")
    end
    Role.find_or_create_by(name: "Assistant Exam Controller").tap do |role|
      role.update!(default_email: self.assistant_exam_controller_email, abbr: "assistant_coe")
    end
    Role.find_or_create_by(name: "Academic Head").tap do |role|
      role.update!(default_email: self.academic_head_email, abbr: "academic_head")
    end
    Role.find_or_create_by(name: "HOD").tap do |role|
      role.update!(default_email: self.hod_email, abbr: "hod")
    end
    Role.find_or_create_by(name: "Student Coordinator").tap do |role|
      role.update!(abbr: "student_coordinator")
    end
    Apartment::Tenant.switch!(current_tenant)
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
