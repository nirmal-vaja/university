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
            block_extra_config = BlockExtraConfig.where(block_extra_config_params).where.not(number_of_supervisions: [nil, 0]).find_by(date: date) 
            if @supervision.list_type.downcase === "junior"
              no_of_blocks = block_extra_config.number_of_supervisions + block_extra_config.number_of_extra_jr_supervision
              supervision = Supervision.where(list_type: 'Junior').where("metadata LIKE ?", "%#{date}");
            else
              no_of_blocks = block_extra_config.number_of_extra_sr_supervision
              supervision = Supervision.where(list_type: 'Senior').where("metadata LIKE ?", "%#{date}");
            end
  
            if supervision.count < no_of_blocks
              metadata[date] = true
            else
              @dates_to_assign = @dates.sample(@supervision.no_of_supervisions)
            end
          end
        end
        @supervision.metadata = metadata
        authorize @supervision
        if @supervision.metadata.present?
          @supervision.no_of_supervisions = @supervision.metadata.length
          if @supervision.save
            render json: {
              message: "Supervision successfully assigned!",
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
          if @dates.empty?
            render json: {
              message: "No Exam Dates found for the selected criteria",
              status: :unprocessable_entity
            }
          else
            render json: {
              message: "You cant assign more supervisions",
              status: :unprocessable_entity
            }
          end
        end
      end

      def update
        @supervision = Supervision.find_by_id(params[:id])
        if @supervision.metadata.length >= supervision_params[:no_of_supervisions].to_i
          @supervision.metadata = {}
        end
        @dates = ExamTimeTable.where(time_table_params).pluck(:date).uniq.map{|date| date.strftime("%Y-%m-%d")}.reject{ |x| @supervision.metadata.keys.include?(x) }
        @dates_to_assign = @dates&.sample(supervision_params[:no_of_supervisions].to_i)
        @block_extra_configs = BlockExtraConfig.where(block_extra_config_params).where.not(number_of_supervisions: [nil, 0])
        metadata = {}
        if @dates_to_assign.present?
          @dates_to_assign.each do |date|
            block_extra_config = @block_extra_configs.find_by(date: date)
            if @supervision.list_type.downcase === "junior"
              no_of_blocks = block_extra_config.number_of_supervisions + block_extra_config.number_of_extra_jr_supervision
              supervisions = Supervision.where(list_type: 'Junior').where("metadata LIKE ?", "%#{date}%")
            else
              no_of_blocks = block_extra_config.number_of_extra_sr_supervision
              supervisions = Supervision.where(list_type: 'Senior').where("metadata LIKE ?", "%#{date}%")
            end
            if supervisions.count < no_of_blocks || supervisions.pluck(:id).include?(@supervision.id)
              @supervision.metadata[date] = true
            else
              @dates_to_assign = @dates.sample(supervision_params[:no_of_supervisions].to_i)
            end
          end
        end

        
        if @supervision.metadata.present?
          if @supervision.update(no_of_supervisions: @supervision.metadata.length)
            render json: {
              message: "Successfully Updated!",
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

      def fetch_details
        user = User.find_by_id(params[:id])
        @supervision = Supervision.find_by(supervision_params.merge(user_id: params[:id]))
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
          if user
            render json: {
              message: "No Supervision data found for #{user.name}, create one!",
              status: :unprocessable_entity
            }
          end
        end
      end

      def destroy
        @supervision = Supervision.find_by_id(params[:id])

        if @supervision.destroy
          render json: {
            message: "Successfully deleted!",
            status: :ok
          }
        else
          render json: {
            message: @supervision.errors.full_messages.join(', '),
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

      def block_extra_config_params
        params.require(:block_extra_config).permit(:examination_name, :examination_type, :academic_year, :course_id, :time)
      end

      def time_table_params
        params.require(:time_table).permit(:name, :subject_id, :day, :date, :time, :academic_year, :course_id, :branch_id, :semester_id, :time_table_type).to_h
      end
    end
  end
end