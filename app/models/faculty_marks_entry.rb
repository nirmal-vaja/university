class FacultyMarksEntry < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :semester
  belongs_to :subject
end
