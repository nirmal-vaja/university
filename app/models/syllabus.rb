class Syllabus < ApplicationRecord
  belongs_to :subject
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  has_one_attached :syllabus_pdf, dependent: :destroy

  validates_presence_of :syllabus_pdf
end
