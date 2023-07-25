class University < ApplicationRecord

  attr_accessor :examination_controller_email, :assistant_exam_controller_email, :academic_head_email, :hod_email, :admin_email, :admin_password, :url

  validates_presence_of :name
  after_create :create_tenant
  after_create :create_doorkeeper_application
  after_create :create_default_roles

  private

  def create_tenant
    Apartment::Tenant.create(subdomain)
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
