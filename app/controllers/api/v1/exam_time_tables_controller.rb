module Api
  module V1
    class ExamTimeTablesController < ApiController
      before_action :set_time_table, only: [:update, :destroy]

      def index
        @exam_time_tables = ExamTimeTable.where(name: params[:examination_name], academic_year: params[:acedemic_year])
        time_tables =  @exam_time_tables.map do |time_table|
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

      def get_examination_dates
        @exam_time_table = ExamTimeTable.find_by_name(params[:examination_name])

        if @exam_time_table
          render json: {
            message: "Examination dates are as below",
            data: {
              dates: @exam_time_table.pluck(:date),
            },status: :ok
          }
        else
          render json: {
            message: "No timetable found for #{params[:examination_name]}",
            status: :unprocessable_entity
          }
        end
      end

      def fetch_details
        subject = Subject.find_by_code(params[:id])
        subject = Subject.find_by_name(params[:id]) unless subject
        @exam_time_table = ExamTimeTable.find_by(subject_id: subject.id)
        
        if @exam_time_table
          render json: {
            message: "Details found",
            data: {
              time_table: @exam_time_table
            }, status: :ok
          }
        else
          render json: {
            message: "No timetable found.",
            status: :unprocessable_entity
          }
        end
      end

      def fetch_subjects
        @exam_time_table = ExamTimeTable.joins(:subject).where(academic_year: params[:id])

        if @exam_time_table
          render json: {
            message: "These are the time table objects",
            data: {
              subject_info: @exam_time_table.pluck(:code, 'subjects.name')
            }, status: :ok
          }
        else
          render json: {
            message: "No time table found",
            status: :unprocessable_entity
          }
        end
      end
      
      def fetch_dates
        @exam_time_tables = ExamTimeTable.where(academic_year: params[:id])
        if @exam_time_tables
          render json: {
            message: "These are the time table objects",
            data: {
              dates: @exam_time_tables.pluck(:date)
            }, status: :ok
          }
        else
          render json: {
            message: "No timetable found for #{academic_year} year",
            status: :unprocessable_entity
          }
        end
      end

      def create
        @exam_time_table = ExamTimeTable.new(time_table_params)
        @exam_time_table.semester = @exam_time_table.subject.semester
        @exam_time_table.branch = @exam_time_table.semester.branch
        @exam_time_table.course = @exam_time_table.branch.course

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
        @time_table = ExamTimeTable.find_by_id(params[:id])
      end

      def time_table_params
        params.require(:time_table).permit(:name, :subject_id, :day, :date, :time, :academic_year)
      end
    end
  end
end