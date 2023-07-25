class User < ApplicationRecord
  rolify

  attr_accessor :subdomain
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_email_format_of :email, message: 'is not a valid email address'
  validates_format_of :phone_number, :with =>  /\+?\d[\d -]{8,12}\d/

  belongs_to :course, optional: true
  belongs_to :branch, optional: true

  has_many :configs, dependent: :destroy

  has_many :faculty_subjects, dependent: :destroy
  has_many :subjects, through: :faculty_subjects

  has_many :supervisions, dependent: :destroy

  has_many :faculty_supervisions, dependent: :destroy
  has_many :subjects_to_supervision, through: :faculty_supervisions, class_name: "Subject", foreign_key: "subject_id"

  has_many :marks_entries, dependent: :destroy

  enum type: {
    "Junior": 0,
    "Senior": 1
  }

  def remove_role_without_deletion(role_name)
    role = Role.find_by_name(role_name)
    roles.delete(role)
  end

  def generate_otp
    self.otp = [1,2,3,4,5,6,7,8,9].sample(6).join("")
    self.otp_generated_at = Time.current
    save
  end

  def send_otp_mail(extra_params = {})
    UserMailer.send_otp_mail(self).deliver_now
  end

  def send_reset_password_instructions(extra_params = {})
    token = set_reset_password_token
    send_devise_notification(:reset_password_instructions, token, extra_params)
    token
  end

  def send_role_assigned_notification(extra_params = {})
    UserMailer.role_assigned_notification(self, extra_params).deliver_now
  end

  def generate_doorkeeper_token
    current_university = University.find_by_subdomain(Apartment::Tenant.current)
    if current_university.present?
      application = Doorkeeper::Application.find_by_name("React client for #{current_university.name}")
      # Generate and store the Doorkeeper access token for the user
      Doorkeeper::AccessToken.create!(
        resource_owner_id: self.id,
        application_id: application.id, # Set the application_id if necessary
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        scopes: Doorkeeper.configuration.default_scopes,
      ).token
    else
      nil
    end
  end

  # the authenticate method from devise documentation
  def self.authenticate(subdomain, email, password, otp = nil, mobile_number = nil)
    if Apartment.tenant_names.include?(subdomain)
      Apartment::Tenant.switch!(subdomain)
      puts "tenant switched"
      user = User.find_for_authentication(email: email) || User.find_for_authentication(phone_number: mobile_number)
      if user && user.status == "true"
        if otp.nil?
          user.valid_password?(password) ? user : nil
        else
          role = user.roles.where.not(name: "faculty").first
          if role
            @user = User.where(
              course_id: user.course.id,
              show: true
            ).with_role(role&.name).last
            if @user.valid_otp?(otp)
              user.generate_doorkeeper_token
              user
            else
              nil
            end
          end
        end
      else
        nil
      end
    end
  end

  def as_json(options = {})
    super(options).merge(
      marks_entries: marks_entries,
      course: course,
      branch: branch
    )
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

  def valid_otp?(otp)
    self.otp == otp
  end

  private

end
