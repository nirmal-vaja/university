module Api
  module V1
    class ExamTimeTablesController < ApiController

      def index
        @exam_time_tables = ExamTimeTable.all
        render json: {
          message: "Successfully fetched all the time tables"
          data: {
            time_tables: @exam_time_tables
          }, status: :ok
        }
      end

      def create
        @exam_time_table = ExamTimeTable.new(time_table_params)

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
            
          }
        end
      end

    end
  end
end