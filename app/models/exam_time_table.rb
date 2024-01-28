class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :branch
  belongs_to :course

  has_many :time_table_block_wise_reports, dependent: :destroy
  has_many :blocks, dependent: :destroy

  after_create :set_day

  attr_accessor :subject_code, :subject_name

  validates_presence_of :name, :time, :date, :time_table_type
  validates :subject_id,  uniqueness: { scope: [:name, :academic_year] }

  enum day: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
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
