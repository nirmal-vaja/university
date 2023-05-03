class Semester < ApplicationRecord
  belongs_to :course
  has_many :subjects, dependent: :destroy

  has_many :exam_time_tables, dependent: :destroy
  
end