require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'chunky_png'
require 'base64'
require 'rqrcode'


class Student < ApplicationRecord

  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division

  has_one :contact_detail, dependent: :destroy
  has_one :address_detail, dependent: :destroy
  has_one :parent_detail, dependent: :destroy
  has_one :guardian_detail, dependent: :destroy
  has_many :student_marks, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :fee_details, through: :payments
  has_many :student_certificates, dependent: :destroy
  has_many :certificates, through: :student_certificates

  scope :fees_paid, -> {where(fees_paid: true)}
  scope :fees_unpaid, -> {where(fees_paid: false)}

  def generate_otp
    self.otp = [1,2,3,4,5,6,7,8,9].sample(6).join("")
    self.otp_generated_at = Time.current
    save
  end

  def move_to_next_semester
    student_branch = branch
    current_semester = semester

    next_semester_name =
      if current_semester.name.to_i == student_branch.semesters.count
        current_semester.name
      else
        current_semester.name.to_i + 1
      end

    next_semester = student_branch.semesters.find_by_name(next_semester_name)
    next_division = next_semester.divisions.find_by(name: division.name)

    if next_semester
      self.update(semester_id: next_semester.id, fees_paid: false, division_id: next_division.id)
    end
  end

  def drag_to_previous_semester
    student_branch = branch
    current_semester = semester

    previous_semester_name =
      if current_semester.name.to_i == 1
        current_semester.name
      else
        current_semester.name.to_i - 1
      end

    previous_semester = student_branch.semesters.find_by_name(previous_semester_name)
    previous_division = previous_semester.divisions.find_by(name: division.name)

    if previous_semester
      self.update(semester_id: previous_semester.id,  fees_paid: false, division_id: previous_division.id)
    end
  end

  def mobile_number
    contact_detail.mobile_number
  end

  def contact_details
    self.contact_detail
  end

  def as_json(options = {})
    super(options).merge(
      course: course,
      branch: branch,
      semester: semester,
      contact_details: contact_detail,
      address_details: address_detail,
      parent_details: parent_detail,
      guardian_details: guardian_detail,
    )
  end

  def self.authenticate(subdomain, mobile_number, otp)
    if Apartment.tenant_names.include?(subdomain)
      Apartment::Tenant.switch!(subdomain)
      puts "tenant switched"
      student = ContactDetail.find_by_mobile_number(mobile_number)&.student || ContactDetail.find_by_personal_email_address(mobile_number)&.student || ContactDetail.find_by_university_email_address(mobile_number)&.student
      student.valid_otp?(otp) ? student : nil
    end
  end

  def valid_otp?(otp)
    self.otp == otp
  end

  private
  
  def generate_barcode
    barcode = Barby::Code128B.new(enrollment_number.to_s)
    outputter = Barby::PngOutputter.new(barcode)
    outputter.xdim = 2 # Adjust the size of the barcode by modifying xdim value
    png_data = outputter.to_png(force_encode: true)
    self.barcode = Base64.strict_encode64(png_data)
  end

  def generate_qrcode
    url = Rails.application.routes.url_helpers.update_fees_api_v1_student_url(self.enrollment_number, only_path: false) # Replace with the actual URL for updating fees_paid
    qrcode = RQRCode::QRCode.new(url)
    png_data = qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 300,
      border_modules: 4,
      module_px_size: 6,
      file: nil # Prevent saving to file
    ).to_s

    self.qrcode = Base64.strict_encode64(png_data)
  end

  def qrcode_url
    "data:image/png;base64,#{qrcode}"
  end

  def barcode_url
    "data:image/png;base64,#{barcode}"
  end
end
