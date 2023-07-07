module Api
  module V1
    class SupervisionsController < ApiController
      before_action :fetch_supervisions, only: [:index]

      def index
        supervisions = @supervisions&.map do |supervision|
          supervision.attributes.merge({
            faculty_name: supervision.user.name,
            designation: supervision.user.designation,
            department: supervision.user.department
          })
        end

        render json: {
          message: "These are all the supervisions",
          data: {
            supervisions: supervisions
          }, status: :ok
        }
      end

      def create
        @supervision = Supervision.new(supervision_params)
        unless supervision_params["branch_id"]
          @supervision.branch_id = @supervision.user.branch.id
        end

        @dates = ExamTimeTable.where(time_table_params).pluck(:date).uniq

        @dates_to_assign = @dates&.sample(@supervision.no_of_supervisions)
        metadata = {}
        if @dates_to_assign.present?
          @dates_to_assign.each do |date|
            date = date.strftime("%Y-%m-%d")
            no_of_blocks = ExamTimeTable.where(date: date).map{|x| x.time_table_block_wise_reports&.pluck(:blocks).compact.sum}.compact.sum
            supervision = Supervision.where("metadata LIKE ?", "%#{date}%")
  
            if supervision.count < no_of_blocks
              metadata[date] = true
            else
              @dates_to_assign = @dates.sample(@supervision.no_of_supervisions)
            end
          end
        else
          
        end
        @supervision.metadata = metadata
        authorize @supervision
        if @supervision.metadata.present?
          if @supervision.save
            render json: {
              message: "List has been saved.",
              data: {
                supervision: @supervision
              }, status: :created
            }
          else
            render json: {
              message: @supervision.errors.full_messages,
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: "You cant assign more supervisions",
            status: :unprocessable_entity
          }
        end
      end

      def update
        @supervision = Supervision.find_by_id(params[:id])

        @dates = ExamTimeTable.where(time_table_params).pluck(:date).uniq
        @dates_to_assign = @dates&.sample(supervision_params[:no_of_supervisions].to_i)
        metadata = {}
        if @dates_to_assign.present?
          @dates_to_assign.each do |date|
            date = date.strftime("%Y-%m-%d")
            no_of_blocks = ExamTimeTable.where(date: date).map{|x| x.time_table_block_wise_reports&.pluck(:blocks).compact.sum}.compact.sum
            supervisions = Supervision.where("metadata LIKE ?", "%#{date}%")
            if supervisions.count < no_of_blocks || supervisions.pluck(:id).include?(@supervision.id)
              metadata[date] = true
            else
              @dates_to_assign = @dates.sample(supervision_params[:no_of_supervisions].to_i)
            end
          end
        end
        
        if metadata.present?
          @supervision.metadata = metadata
          if @supervision.update(supervision_params)
            render json: {
              message: "Supervision Altered",
              data: {
                supervision: @supervision
              }, status: :ok
            }
          else
            render json: {
              message: @supervision.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: "You cant assign more supervisions",
            status: :unprocessable_entity
          }
        end
      end

      # def update
      #   @supervision = Supervision.find_by_id(params[:id])
      #   unless params["branch_id"]
      #     @supervision.branch_id = @supervision.user.branch.id
      #   end
      #   @supervision.metadata = params["supervision"]["metadata"]
        
      #   authorize @supervision
      #   if @supervision.metadata
      #     if @supervision.metadata.count <= @supervision.no_of_supervisions
      #       if @supervision.update(supervision_params)
      #         render json: {
      #           message: "Supervision Altered",
      #           data: {
      #             supervision: @supervision
      #           }, status: :ok
      #         }
      #       else
      #         render json: {
      #           message: @supervision.errors.full_messages.join(', '),
      #           status: :unprocessable_entity
      #         }
      #       end
      #     else
      #       render json: {
      #         message: "You can't assign more than #{@supervision.no_of_supervisions}!",
      #         status: :unprocessable_entity
      #       }
      #     end
      #   else
      #     if @supervision.update(supervision_params)
      #       render json: {
      #         message: "Supervision Altered",
      #         data: {
      #           supervision: @supervision
      #         }, status: :ok
      #       }
      #     else
      #       render json: {
      #         message: @supervision.errors.full_messages.join(', '),
      #         status: :unprocessable_entity
      #       }
      #     end
      #   end
      # end

      def fetch_details
        user = User.find_by_id(params[:id])
        @supervision = Supervision.where(user_id: user.id )
        @supervision = Supervision.find_by(supervision_params)
        supervision = @supervision.attributes.merge(
          {
            user_name: user.name,
            designation: user.designation,
            course_name: user.course.name
          }
        ) if @supervision.present?

        if supervision
          render json: {
            message: "Details found",
            data: {
              supervision: supervision
            }, status: :ok
          }
        else
          render json: {
            message: "No Supervision data found for #{user.name}, create one!",
            status: :unprocessable_entity
          }
        end
      end

      private

      def fetch_supervisions
        @supervisions = Supervision.where(supervision_params.except(:date))
        if(supervision_params[:date].present?)
          @supervisions = @supervisions.where("metadata LIKE ?", "%#{supervision_params[:date]}%")
        end
      end

      def supervision_params
        params.require(:supervision).permit(:examination_name, :academic_year, :metadata, :list_type, :user_id, :no_of_supervisions, :course_id, :branch_id, :semester_id, :date, :time, :supervision_type).to_h
      end

      def time_table_params
        params.require(:time_table).permit(:name, :subject_id, :day, :date, :time, :academic_year, :course_id, :branch_id, :semester_id, :time_table_type).to_h
      end
    end
  end
end