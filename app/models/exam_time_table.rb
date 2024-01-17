class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :branch
  belongs_to :course

  has_many :time_table_block_wise_reports, dependent: :destroy

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

  def create_block_details
    block_wise = TimeTableBlockWiseReport.create(block_details_params(self))
    
    ('A'..('A'.ord + block_wise.number_of_blocks - 1).chr).each do |block_name|
      block_wise.blocks.create(block_params(block_wise, block_name))
    end
  end

  private

  def block_details_params(time_table)
    max_students_per_block = ExaminationType.find_by(name: time_table.time_table_type).max_studentsper_block
    no_of_students = Student.where(branch_id: time_table.branch_id,semester_id: time_table.semester_id, fees_paid: true).count
    blocks = (no_of_students.to_f) / max_students_per_block
    
    {
      exam_time_table_id: time_table.id,
      number_of_blocks: blocks.ceil(),
      academic_year: time_table.academic_year,
      no_of_students: no_of_students,
      examination_name: time_table.name,
      course_id: time_table.course_id,
      branch_id: time_table.branch_id,
      semester_id: time_table.semester_id,
      report_type: time_table.time_table_type
    }
  end

  def block_params(block_wise_report, block_name)
    {
      name: block_name,
      academic_year: block_wise_report.academic_year, 
      examination_name: block_wise_report.examination_name,
      course: block_wise_report.course,
      branch: block_wise_report.branch,
      semester: block_wise_report.semester,
      block_type: block_wise_report.report_type
    }
  end

  def set_day
    self.day = date.wday
    self.save
  end
end
