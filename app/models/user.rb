class User < ApplicationRecord
  rolify

  attr_accessor :subdomain
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates_format_of :phone_number, :with =>  /\+?\d[\d -]{8,12}\d/

  belongs_to :course, optional: true
  belongs_to :branch, optional: true

  has_one :configuration, dependent: :destroy

  has_many :faculty_subjects, dependent: :destroy
  has_many :subjects, through: :faculty_subjects

  has_many :supervisions, dependent: :destroy

  has_many :faculty_supervisions, dependent: :destroy
  has_many :subjects_to_supervision, through: :faculty_supervisions, class_name: "Subject", foreign_key: "subject_id"

  enum type: {
    "Junior": 0,
    "Senior": 1
  }

  def remove_role_without_deletion(role_name)
    role = Role.find_by_name(role_name)
    roles.delete(role)
  end

  def send_reset_password_instructions(extra_params = {})
    token = set_reset_password_token
    send_devise_notification(:reset_password_instructions, token, extra_params)
    token
  end

  # the authenticate method from devise documentation
  def self.authenticate(subdomain, email, password)
    if Apartment.tenant_names.include?(subdomain)
      Apartment::Tenant.switch!(subdomain)
      puts "tenant switched"
      user = User.find_for_authentication(email: email)
      user&.valid_password?(password) && user&.status == "true" ? user : nil
    end
  end

  def name
    "#{first_name} #{last_name}"
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
