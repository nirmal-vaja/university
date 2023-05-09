class Semester < ApplicationRecord
  belongs_to :branch
  has_many :subjects, dependent: :destroy

  has_many :exam_time_tables, dependent: :destroy
  
end