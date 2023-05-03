module Api
  module V1
    class ExamTimeTablesController < ApiController
      before_action :set_time_table, only: [:update, :destroy]

      def index
        @exam_time_tables = ExamTimeTable.all
        render json: {
          message: "Successfully fetched all the time tables",
          data: {
            time_tables: @exam_time_tables
          }, status: :ok
        }
      end

      def create
        @exam_time_table = ExamTimeTable.new(time_table_params)
        @exam_time_table.course = Course.find_by_name(time_table_params[:department])
        @exam_time_table.branch = Branch.find_by_name(time_table_params[:branch])
        @exam_time_table.semester = Semester.find_by_name(time_table_params[:semester_name])
        @exam_time_table.subject = Subject.find_by_code(time_table_params[:subject_code])

        if @exam_time_table.save
          render json: {
            message: "Time table has been created",
            data: {
              time_table: @exam_time_table
            }, status: :created
          }
        else
          render json: {
            message: @exam_time_table.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @time_table.update(time_table_params)
          render json: {
            message: "Time table has been updated",
            data: {
              time_table: @time_table
            }, status: :ok
          }
        else
          render json: {
            message: @time_table.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @time_table.destroy
          render json: {
            message: "Time Table has been destroyed",
            status: :ok
          }
        else
          render json: {
            message: @time_table.errors.full_messages.join(' '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def set_time_table
        @time_table = TimeTable.find_by_id(params[:id])
      end

      def time_table_params
        params.require(:time_table).permit(:name, :department, :branch, :semester_name, :subject_code, :subject_name, :day, :date, :time)
      end
    end
  end
end