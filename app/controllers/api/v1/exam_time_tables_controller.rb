module Api
  module V1
    class ExamTimeTablesController < ApiController
      before_action :set_time_table, only: [:update, :destroy]
      before_action :fetch_time_tables, only: [:index, :get_examination_dates]

      def index
        time_tables = @exam_time_tables.map do |time_table|
          time_table.attributes.merge({
            subject_name: time_table.subject_name,
            subject_code: time_table.subject_code,
          })
        end
        render json: {
          message: "Successfully fetched all the time tables",
          data: {
            time_tables: time_tables
          }, status: :ok
        }
      end

      def create
        @exam_time_table = ExamTimeTable.new(time_table_params)
        @exam_time_table.semester = @exam_time_table.subject.semester
        @exam_time_table.branch = @exam_time_table.semester.branch
        @exam_time_table.course = @exam_time_table.branch.course
        authorize @exam_time_table
        
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

      def get_examination_dates
        if @exam_time_tables
          render json: {
            message: "Examination dates are as below",
            data: {
              dates: @exam_time_tables.pluck(:date).uniq,
            },status: :ok
          }
        else
          render json: {
            message: "No timetable found",
            status: :unprocessable_entity
          }
        end
      end

      def fetch_details
        @exam_time_table = ExamTimeTable.where(time_table_params)
        @exam_time_table = @exam_time_table.find_by(subject_id: params[:id])
        exam_time_table = @exam_time_table.attributes.merge(
          {
            subject_name: subject.name,
            subject_code: subject.code
          }
        ) if @exam_time_table.present?
        
        if exam_time_table
          render json: {
            message: "Details found",
            data: {
              time_table: exam_time_table
            }, status: :ok
          }
        else
          render json: {
            message: "No Details found",
            status: :unprocessable_entity
          }
        end
      end

      private

      def set_time_table
        @time_table = ExamTimeTable.find_by_id(params[:id])
      end

      def fetch_time_tables_using_name_and_year
        @exam_time_tables = ExamTimeTable.where(name: params[:examination_name]).or(
          ExamTimeTable.where(academic_year: params[:academic_year])
        )
      end

      def fetch_time_tables
        @exam_time_tables = ExamTimeTable.where(time_table_params)
      end

      def time_table_params
        params.require(:time_table).permit(:name, :subject_id, :day, :date, :time, :academic_year, :course_id, :branch_id, :semester_id, :time_table_type).to_h
      end
    end
  end
end