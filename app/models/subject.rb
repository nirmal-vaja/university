class Subject < ApplicationRecord
  belongs_to :semester
  has_many :faculty_subjects, dependent: :destroy
  has_many :users, through: :faculty_subjects

  has_many :exam_time_tables, dependent: :destroy
end