class ExcelSheet < ApplicationRecord
  require "rake"
  has_one_attached :sheet, dependent: :destroy
  # to remove the sheet from s3 use purge method on the object!

  after_create :save_data

  private

  def save_data
    Rails.application.load_tasks
    case name
    when "Faculty Details"
      Rake::Task['import:faculty_details'].invoke(self.id)
    when "Course and Semester Details"
      Rake::Task['import:course_and_semester'].invoke(self.id)
    when "Subject Details"
      Rake::Task['import:subject_details'].invoke(self.id)
    when "Faculty Supervision"
      Rake::Task['import:supervision_list'].invoke(self.id)
    when "Marks Entry Details"
      Rake::Task['import:marks_entry'].invoke(self.id)
    when "Faculty Assignment for marks entry"
      Rake::Task['import:faculty_assignment_for_marks_entry'].invoke(self.id)
    end
  end
end