class StudentMark < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division
  belongs_to :subject
  belongs_to :student

  validate :marks_within_maximum_marks

  def marks_within_maximum_marks
    type = ExaminationType.find_by_name(examination_type) 
    if marks.present? && ( marks != "Ab" && marks != "ZR" ) && marks > type.maximum_marks
      errors.add(:marks, "cannot exceed maximum marks for #{examination_type}")
    end
  end
end
