class ReportGenerator

  attr_accessor :academic_year, :no_of_students

  def initialize(academic_year, no_of_students = 100)
    @academic_year = academic_year
    @no_of_students = no_of_students
  end

  def create_report
    @exam_time_tables = ExamTimeTable.where(academic_year: @academic_year)
    TimeTableBlockWiseReport.where(academic_year: @academic_year).destroy_all
    equation = @no_of_students / 30
    success = 0
    reports = 0
    @exam_time_tables.each do |time_table|
      report = TimeTableBlockWiseReport.new(
        exam_time_table_id: time_table.id,
        rooms: equation.ceil(),
        blocks: equation.ceil(),
        academic_year: @academic_year
      )
      report += 1
      if report.save
        success +=1
      else
        return { message: report.errors.full_messages.join(' '), status: :unprocessable_entity }
      end
    end

    if success == reports
      {
        message: "Reports for #{@academic_year} has been generated.",
        data: {
          reports: TimeTableBlockWiseReport.where(academic_year: @academic_year)
        }, status: :created
      }
    end
  end
end