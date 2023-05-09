class TimeTableBlockWiseReport < ApplicationRecord
  attr_accessor :no_of_students

  belongs_to :exam_time_table
end
