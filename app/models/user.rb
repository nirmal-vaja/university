class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates_format_of :phone_number, :with =>  /\+?\d[\d -]{8,12}\d/

  belongs_to :course, optional: true
  belongs_to :branch, optional: true

  has_many :faculty_subjects, dependent: :destroy
  has_many :subjects, through: :faculty_subjects

  has_many :supervisions, dependent: :destroy

  has_many :faculty_supervisions, dependent: :destroy
  has_many :subjects_to_supervision, through: :faculty_supervisions, class_name: "Subject", foreign_key: "subject_id"

  enum type: {
    "Junior": 0,
    "Senior": 1
  }

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
