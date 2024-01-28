class Api::V1::BlocksController < ApiController

  before_action :set_block, only: %i[assign_students]

  def index
    # @blocks = Block
    #             .where(block_params)
    #             .select{ |block| block.number_of_students < block.capacity }
    @blocks = Block.left_outer_joins(:rooms).where(block_params).where(rooms: { id: nil })

    if @blocks
      render json: {
        message: "Blocks found",
        data: {
          blocks: @blocks,
        },
        status: :ok
      }
    else
      render json: {
        data: {
          message: "Block not found",
          status: :not_found
        }
      }
    end
  end

  def fetch_data_date_wise
    @blocks = Block.where(block_params)
    @number_of_blocks = @blocks.count

    if @number_of_blocks > 0
      render json: {
        message: "Blocks found",
        data: {
          number_of_blocks: @number_of_blocks
        }, status: :ok
      }
    else
      render json: {
        message: "No blocks found for this date",
        status: :unprocessable_entity
      }
    end
  end

  def assign_students
    @students = Student.where(id: params[:student_ids])

    unless valid_students?
      render_error("No valid students selected.", :unprocessable_entity)
      return
    end

    if capacity_exceeded?
      render_error("Assignment failed. Capacity exceeded.", :unprocessable_entity)
      return
    end

    assign_students_to_block

    render_success("Selected students are assigned to Block " + @block.name)
  end

  private

  def set_block
    @block = Block.find_by_id(params[:id])
  end

  def valid_students?
    @students.present?
  end

  def capacity_exceeded?
    @students.count + @block.students.count > @block.capacity
  end

  def assign_students_to_block
    @students.each do |student|
      @block.student_blocks.create(
        student_id: student.id,
        examination_name: @block.examination_name,
        academic_year: @block.academic_year,
        course_id: @block.course_id,
        branch_id: @block.branch_id,
      )
    end
    @block.reload
    @block.update(number_of_students: @block.students.count);
  end

  def render_error(message, status)
    render json: {
      data: {
        message: message,
        status: status
      }
    }
  end

  def render_success(message)
    render json: {
      data: {
        message: message,
        status: :ok
      }
    }
  end

  def block_params
    params.require(:block).permit(
      :academic_year,
      :examination_name,
      :course_id,
      :branch_id,
      :semester_id,
      :block_type
    )
  end

  def time_table_params
    params.require(:time_table).permit(
      :academic_year,
      :name,
      :time_table_type,
      :course_id,
      :branch_id,
      :semester_id,
      :subject_id,
      :date,
      :time
    )
  end
end