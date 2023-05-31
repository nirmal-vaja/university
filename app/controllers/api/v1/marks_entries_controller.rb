module Api
  module V1
    class MarksEntriesController < ApiController
      before_action :find_mark_entry, only: [:update, :destroy]

      def index
        @entries = MarksEntry.where(marks_entry_params)
        
        if @entries
          entries = @entries.map do |entry|
            entry.attributes.merge({
              faculty_name: entry.user.name,
              designation: entry.user.designation,
              department: entry.user.branch.name,
              subjects: entry.subjects
            })
          end

          render json: {
            message: "Details found",
            data: {
              marks_entries: entries
            }, status: :ok
          }
        else
          render json: {
            message: "No details found",
            status: :unprocessable_entity
          }
        end
      end

      def create
        @marks_entry = MarksEntry.new(marks_entry_params)

        if @marks_entry.save
          render json: {
            message: "Faculty successfully assigned",
            data: {
              marks_entry: @marks_entry
            }, status: :created
          }
        else
          render json: {
            message: @marks_entry.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @marks_entry.update(marks_entry_params)
          render json: {
            message: "Update successful",
            data: {
              marks_entry: @marks_entry
            }, status: :ok
          }
        else
          render json: {
            message: @marks_entry.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def destroy
        if @marks_entry.destroy
          render json: {
            message: "Deleted!",
            status: :ok
          }
        else
          render json: {
            message: @marks_entry.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      private

      def find_mark_entry
        @marks_entry = MarksEntry.find_by_id(params[:id])
      end

      def marks_entry_params
        params.require(:marks_entry).permit(:examination_name, :academic_year, :course_id, :branch_id, :semester_id, :user_id, subject_ids: []).to_h
      end

    end
  end
end