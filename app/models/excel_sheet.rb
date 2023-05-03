class ExcelSheet < ApplicationRecord
  require "rake"
  has_one_attached :sheet, dependent: :destroy
  # to remove the sheet from s3 use purge method on the object!

  validates_presence_of :sheet, :name
  validates_uniqueness_of :name
end
