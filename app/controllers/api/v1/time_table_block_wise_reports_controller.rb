module Api
  module V1
    class TimeTableBlockWiseReportsController < ApiController

      def index
        @reports = TimeTableBlockWiseReport.all
        render json: {
          message: "These are the reports",
          data: {
            reports: @reports
          }, status: :ok
        }
      end

      def create
        @report = TimeTableBlockWiseReport.new(report_params)
        subject = Subject.find_by_code(params[:subject_code]) if params[:subject_code]
        subject = Subject.find_by_name(params[:subject_name]) if params[:subject_name]

        @report.exam_time_table = ExamTimeTable.find_by(subject_id: subject.id)
        equation = @report.no_of_students / 30
        @report.rooms = equation.ceil()
        @report.block = equation.ceil()

        if @report.save
          render json: {
            message: "Report created",
            data: {
              report: @report
            }, status: :ok
          }
        else
          render json: {
            message: @report.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def report_params
        params.require(:report).permit(:academic_year, :no_of_students)
      end
    end
  end
end