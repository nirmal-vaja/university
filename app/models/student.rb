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

  before_save :generate_barcode, :generate_qrcode

  scope :fees_paid, -> {where(fees_paid: true)}

  def generate_barcode
    barcode = Barby::Code128B.new(enrollment_number.to_s)
    outputter = Barby::PngOutputter.new(barcode)
    outputter.xdim = 2 # Adjust the size of the barcode by modifying xdim value
    png_data = outputter.to_png(force_encode: true)
    self.barcode = Base64.strict_encode64(png_data)
  end

  def generate_qrcode
    url = "http://ec2-13-234-111-241.ap-south-1.compute.amazonaws.com/api/v1/students/#{enrollment_number}/update_fees" # Replace with the actual URL for updating fees_paid
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
    binding.pry
  end

  def qrcode_url
    "data:image/png;base64,#{qrcode}"
  end

  def barcode_url
    "data:image/png;base64,#{barcode}"
  end
end
