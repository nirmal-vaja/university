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

          @configuration = Config.find_or_initialize_by(
            examination_name: @marks_entry.examination_name,
            examination_type: @marks_entry.entry_type,
            academic_year: @marks_entry.academic_year,
            course_id: @marks_entry.course_id,
            branch_id: @marks_entry.branch_id,
            user_id: @marks_entry.user_id
          )

          if @configuration.save
            configuration_semester = @configuration.configuration_semesters.find_or_initialize_by(
              semester_id: @marks_entry.semester_id,
              division_id: @marks_entry.division_id
            )
            configuration_semester&.subject_ids = @marks_entry.subjects.pluck(:id)

            if configuration_semester && configuration_semester.save
              @marks_entry.user.add_role("Marks Entry") unless @marks_entry.user.has_role?("Marks Entry")
              UserMailer.send_marks_entry_notification(@marks_entry.user, url: params[:url], role_name: "Marks Entry", subject_names: @marks_entry.subjects.pluck(:name)).deliver_now
              render json: {
                message: "Faculty successfully assigned",
                data: {
                  marks_entry: @marks_entry
                }, status: :created
              }
            else 
              render json: {
                message: configuration_semester.errors.full_messages.join(', '),
                status: :unprocessable_entity
              }
            end
          else
            render json: {
              message: @configuration.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: @marks_entry.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end

      def update
        if @marks_entry.update(marks_entry_params)

          user = @marks_entry.user

          config = user.configs&.find_by(
            examination_name: @marks_entry.examination_name,
            examination_type: @marks_entry.entry_type,
            academic_year: @marks_entry.academic_year,
            course_id: @marks_entry.course_id,
            branch_id: @marks_entry.branch_id,
          )

          configuration_semester = config.configuration_semesters.find_by(
            semester_id: @marks_entry.semester_id,
            division_id: @marks_entry.division_id
          )

          if configuration_semester.update(subject_ids: @marks_entry.subjects.pluck(:id))
            render json: {
              message: "Update successful",
              data: {
                marks_entry: @marks_entry
              }, status: :ok
            }
          else
            render json: {
              message: configuration_semester.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
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

      def fetch_details
        user = User.find_by_id(params[:id])
        @marks_entry = MarksEntry.where(user_id: user.id )
        @marks_entry = MarksEntry.find_by(marks_entry_params)
        marks_entry = @marks_entry.attributes.merge(
          {
            user_name: user.name,
            designation: user.designation,
            course_name: user.course.name,
            subjects: @marks_entry.subjects
          }
        ) if @marks_entry.present?

        if marks_entry
          render json: {
            message: "Details found",
            data: {
              marks_entry: marks_entry
            }, status: :ok
          }
        else
          render json: {
            message: "Nothing is assigned to #{user.name}",
            status: :not_found
          }
        end
      end

      private

      def find_mark_entry
        @marks_entry = MarksEntry.find_by_id(params[:id])
      end

      def marks_entry_params
        params.require(:marks_entry).permit(:examination_name, :academic_year, :course_id, :branch_id, :semester_id, :division_id, :user_id, :entry_type, subject_ids: []).to_h
      end

    end
  end
end