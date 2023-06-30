class Syllabus < ApplicationRecord
  belongs_to :subject
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  attr_accessor :subject_code, :subject_name

  has_one_attached :syllabus_pdf, dependent: :destroy

  validates_presence_of :syllabus_pdf

  def subject_code
    subject.code
  end

  def subject_name
    subject.name
  end
end
