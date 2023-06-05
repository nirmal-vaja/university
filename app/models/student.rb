class Student < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
end
