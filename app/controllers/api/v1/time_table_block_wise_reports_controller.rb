module Api
  module V1
    class TimeTableBlockWiseReportsController < ApiController

      before_action :set_report, only: [:update, :destroy]

      def index
        @reports = TimeTableBlockWiseReport.where(report_params.except(:date, :time))

        if report_params[:date].present?
          @reports = @reports.joins(:exam_time_table).where('exam_time_table.date' => report_params[:date])
        end

        if report_params[:time].present?
          @reports = @reports.joins(:exam_time_table).where('exam_time_table.time' => report_params[:time])
        end

        reports = @reports.map do |report|
          report.attributes.merge({
            subject_name: report.exam_time_table.subject_name,
            subject_code: report.exam_time_table.subject_code,
            data: report.exam_time_table.date,
            time: report.exam_time_table.time
          })
        end

        render json: {
          message: "These are the reports",
          data: {
            reports: reports
          }, status: :ok
        }
      end

      def fetch_details
        exam_time_table = ExamTimeTable.find_by_id(params[:id])
        @report = TimeTableBlockWiseReport.find_by(exam_time_table_id: params[:id])

        if @report
          render json: {
            message: "Details found",
            data: {
              report: @report
            },status: :ok
          }
        else
          render json: {
            message: "No Details found for #{exam_time_table.subject.name} ",
            status: :unprocessable_entity
          }
        end
      end

      def create
        @report = TimeTableBlockWiseReport.new(report_params)
        @report.course = @report.exam_time_table.course
        @report.branch = @report.exam_time_table.branch
        @report.semester = @report.exam_time_table.semester

        equation = @report.no_of_students.to_f / 30
        @report.blocks = equation.ceil()

        if @report.save
          render json: {
            message: "Created Successfully!",
            data: {
              report: @report
            }, status: :created
          }
        else
          render json: {
            message: @report.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        @report.no_of_students = params[:report][:no_of_students]
        equation = @report.no_of_students.to_f / 30
        @report.blocks = equation.ceil()

        if @report.save
          render json: {
            message: "Successfully Updated!",
            data: {
              report: @report,
            }, status: :ok
          }
        else
          render json: {
            message: @report.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @report.destroy
          render json: {
            message: "Successfully Deleted!",
            status: :ok
          }
        else
          render json: {
            message: @report.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def set_report
        @report = TimeTableBlockWiseReport.find_by_id(params[:id])
      end

      def report_params
        params.require(:report).permit(:academic_year, :no_of_students, :exam_time_table_id, :examination_name, :course_id, :branch_id, :semester_id, :date, :time, :report_type).to_h
      end
    end
  end
end