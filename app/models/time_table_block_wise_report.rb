class TimeTableBlockWiseReport < ApplicationRecord
  attr_accessor :date, :time
  belongs_to :exam_time_table
  belongs_to :course
  belongs_to :branch, optional: true
  belongs_to :semester, optional: true

  validates_presence_of :no_of_students

end
