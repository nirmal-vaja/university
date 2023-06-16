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
          
          email = @marks_entry.user.email.split("@").join("_me_#{@marks_entry.entry_type.downcase}@")
          password = SecureRandom.hex

          user = User.new(
              first_name: @marks_entry.user.first_name,
              last_name: @marks_entry.user.last_name,
              email: email,
              password: password,
              gender: @marks_entry.user.gender,
              status: "true",
              phone_number: @marks_entry.user.phone_number,
              department: @marks_entry.user.department,
              designation: @marks_entry.user.designation,
              course_id: @marks_entry.user.course_id,
              branch_id: @marks_entry.user.branch_id,
              user_type: @marks_entry.user.user_type
            )

          configuration = user.build_configuration(
            examination_name: @marks_entry.examination_name,
            examination_type: @marks_entry.entry_type,
            academic_year: @marks_entry.academic_year,
            course_id: @marks_entry.course_id,
            branch_id: @marks_entry.branch_id,
            semester_id: @marks_entry.semester_id,
            division_id: @marks_entry.division_id,
            subject_ids: @marks_entry.subjects.pluck(:id)
          )

          if user.save
            user.add_role("Marks Entry") unless user.has_role?("Marks Entry")
            if configuration.save
              marks_entry = 
                if @marks_entry.subjects
                  @marks_entry.attributes.merge({
                    subjects: @marks_entry.subjects,
                    password: password
                  })
                else
                  @marks_entry
                end

              render json: {
                message: "Faculty successfully assigned",
                data: {
                  marks_entry: marks_entry
                }, status: :created
              }
            else
              render json: {
                message: "There is some exception assigning this faculty! Try again later.",
                status: :unprocessable_entity
              }
            end
          else
            render json: {
              message: "There is some exception assigning this faculty! Try again later.",
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
          email = @marks_entry.user.email.split("@").join("_me_#{@marks_entry.entry_type.downcase}@")

          user = User.find_by(email: email)

          user&.configuration&.update(
            examination_name: @marks_entry.examination_name,
            examination_type: @marks_entry.entry_type,
            academic_year: @marks_entry.academic_year,
            course_id: @marks_entry.course_id,
            branch_id: @marks_entry.branch_id,
            semester_id: @marks_entry.semester_id,
            division_id: @marks_entry.division_id,
            subject_ids: @marks_entry.subjects.pluck(:id)
          )

          marks_entry = 
            if @marks_entry.subjects
              @marks_entry.attributes.merge({
                subjects: @marks_entry.subjects
              })
            else
              @marks_entry
            end
            
          render json: {
            message: "Update successful",
            data: {
              marks_entry: marks_entry
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