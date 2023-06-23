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
        @excel_sheet = ExcelSheet.find_by_name(excel_sheet_params[:name])

        if @excel_sheet
          authorize @excel_sheet
          if @excel_sheet.update(excel_sheet_params)
            if @excel_sheet.sheet.attached?
              render json: run_creator(@excel_sheet.id)
            else
              render json: {
                message: "The excel sheet has not been uploaded properly, kindly upload it again!",
                status: :unprocessable_entity
              }
            end
          else
            render json: {
              message: @excel_sheet.errors.full_messages.join(' '),
              status: :unprocessable_entity
            }
          end
        else
          @excel_sheet = ExcelSheet.new(excel_sheet_params)
          authorize @excel_sheet
          if @excel_sheet.save
            render json: run_creator(@excel_sheet.id)
          else
            render json: {
              message: @excel_sheet.errors.full_messages.join(' '),
              status: :unprocessable_entity
            }
          end
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

      def run_creator(excel_sheet_id)
        excel_sheet = ExcelSheet.find_by_id(excel_sheet_id)

        case excel_sheet.name
        when "Faculty Details"
          Importer.new(excel_sheet.id).create_faculty_details
        when "Course and Semester Details"
          Importer.new(excel_sheet.id).create_course_and_semester
        when "Subject Details"
          Importer.new(excel_sheet.id).create_subject
        when "Division Details"
          Importer.new(excel_sheet.id).create_divisions
        when "Student Details"
          Importer.new(excel_sheet.id).create_students
        when "Syllabus Details"
          Importer.new(excel_sheet.id).create_syllabus
        end
      end

      def find_excel_sheet
        @excel_sheet = ExcelSheet.find_by_id(params[:id])
      end

      def excel_sheet_params
        params.require(:excel_sheet).permit(:name, :sheet)
      end
    end
  end
end