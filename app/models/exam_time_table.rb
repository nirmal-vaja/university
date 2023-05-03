class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject

  validates_presence_of :name, :department, :day, :time, :date
  enum day: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  enum time: {
    morning: "10:30 A.M to 01:00 P.M",
    evening: "03:00 P.M to 05:30 P.M"
  }

  

end
