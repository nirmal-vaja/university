class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :branch
  belongs_to :course

  after_create :set_day

  attr_accessor :subject_code, :subject_name

  validates_presence_of :name, :time, :date
  validates :subject_id,  uniqueness: { scope: [:name, :academic_year] }

  enum day: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    firday: 5,
    saturday: 6
  }

  enum time: {
    "10:30 A.M to 01:00 P.M": "morning" ,
    "03:00 P.M to 05:30 P.M": "evening"
  }

  def subject_code
    subject.code
  end

  def subject_name
    subject.name
  end

  private

  def set_day
    self.day = date.wday
    self.save
  end
end
