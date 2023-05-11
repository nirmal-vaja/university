class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :branch
  belongs_to :course

  after_create :set_day

  attr_accessor :subject_code, :subject_name

  validates_presence_of :name, :time, :date
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

  def subject_code
    subject.code
  end

  def subject_name
    subject.name
  end

  private

  def set_day
    self.update(day: date.strftime("%A").downcase)
  end
end
