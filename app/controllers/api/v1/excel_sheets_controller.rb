module Api
  module V1
    class ExcelSheetsController < ApiController
      skip_before_action :doorkeeper_authorize!
      before_action :find_excel_sheet, only: [:update, :destroy]

      def index
        @excel_sheets = ExcelSheet.all

        render json: {
          data: {
            excel_sheets: @excel_sheets
          }, status: :ok
        }
      end

      def create
        @excel_sheet = ExcelSheet.new(excel_sheet_params)

        if @excel_sheet.save

          case @excel_sheet.name
          when "Faculty Details"
            Importer.new(@excel_sheet.id).create_faculty_details
          when "Course and Semester Details"
            Importer.new(@excel_sheet.id).create_course_and_semester
          when "Subject Details"
            Importer.new(@excel_sheet.id).create_subject
          end

          render json: {
            data: {
              excel_sheet: @excel_sheet
            },status: :created,
            message: "Excel Sheet has been uploaded"
          }
        else
          render json: {
            message: @excel_sheet.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @excel_sheet.update(excel_sheet_params)
          render json: {
            data: {
              excel_sheet: @excel_sheet
            }, status: :ok,
            message: "Excel sheet has been updated"
          }
        else
          render json: {
            message: @excel_sheet.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @excel_sheet.destroy
          render json: {
            message: "Excel has been destroy",
            status: :ok
          }
        else
          render json: {
            message: @excel_sheet.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def find_excel_sheet
        @excel_sheet = ExcelSheet.find_by_id(params[:id])
      end

      def excel_sheet_params
        params.require(:excel_sheet).permit(:name, :sheet)
      end
    end
  end
end