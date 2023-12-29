class Certificate < ApplicationRecord
  validates :name, presence: true
  validates :amount, presence: true

  has_many :student_certificates, dependent: :destroy
  has_many :students, through: :student_certificates
  has_one_attached :template, dependent: :destroy
end
