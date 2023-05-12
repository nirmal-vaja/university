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

        equation = @report.no_of_students / 30
        @report.rooms = equation.ceil()
        @report.block = equation.ceil()

        if @report.save
          render json: {
            message: "Report created",
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

      private

      def report_params
        params.require(:report).permit(:academic_year, :no_of_students, :exam_time_table_id)
      end
    end
  end
end