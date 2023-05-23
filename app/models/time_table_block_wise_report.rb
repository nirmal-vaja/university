class TimeTableBlockWiseReport < ApplicationRecord
  belongs_to :exam_time_table

  validates_presence_of :no_of_students
end
