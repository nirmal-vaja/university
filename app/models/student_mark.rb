class StudentMark < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division
  belongs_to :subject
  belongs_to :student
end
