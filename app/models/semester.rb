class Semester < ApplicationRecord
  belongs_to :branch
  has_many :subjects, dependent: :destroy
  has_many :divisions, dependent: :destroy

  has_many :exam_time_tables, dependent: :destroy

  has_many :students, dependent: :destroy

  has_many :configurations, dependent: :destroy
  
end