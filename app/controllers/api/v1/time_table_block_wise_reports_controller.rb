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
        ReportGenerator.new(report_params).create_report
      end

      private

      def report_params
        params.require(:report).permit(:academic_year, :no_of_students)
      end
    end
  end
end