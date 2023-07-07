require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'chunky_png'
require 'base64'
require 'rqrcode'


class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  has_many :student_marks, dependent: :destroy
  # before_save :generate_barcode, :generate_qrcode

  scope :fees_paid, -> {where(fees_paid: true)}

  def self.authenticate(subdomain, email, password)
    if Apartment.tenant_names.include?(subdomain)
      Apartment::Tenant.switch!(subdomain)
      puts "tenant switched"
      student = Student.find_for_authentication(email: email)
      student&.valid_password?(password) && student&.status == "true" ? student : nil
    end
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
