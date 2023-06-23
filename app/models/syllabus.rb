class Syllabus < ApplicationRecord
  belongs_to :subject
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
end
