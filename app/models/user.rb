class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP

  # the authenticate method from devise documentation
  def self.authenticate(subdomain, email, password)
    if Apartment.tenant_names.include?(subdomain)
      Apartment::Tenant.switch!(subdomain)
      puts "tenant switched"
      user = User.find_for_authentication(email: email)
      user&.valid_password?(password) ? user : nil
    end
  end

  def examination_controller?
    self.has_role? :examination_controller
  end

  def assistant_exam_controller?
    self.has_role? :assistant_exam_controller
  end

  def academic_head?
    self.has_role? :academic_head
  end

  def hod?
    self.has_role? :hod
  end
  
end