class Api::V1::BlocksController < ApiController

  before_action :set_block, only: %i[assign_students fetch_details reassign_block]

  def index
    @blocks = Block.joins(:subject).where(block_params).where.not(number_of_students: 0).order('subjects.name, name')
    if @blocks.present?
      render json: {
        message: "Blocks found",
        data: {
          blocks: @blocks,
        },
        status: :ok
      }
    else
      render json: {
        message: "No blocks found or No students are assigned to any blocks for the selected filters!",
        status: :not_found
      }
    end
  end

  def fetch_details
    return render json: {message: 'No rooms assigned', status: :unprocessable_entity} unless @block.rooms

    @details = @block.room_blocks.find_by(room_block_params)

    if @details
      render json: {
        message: "Room Block Found",
        data: { details: @details },
        status: :ok
      }
    else
      render json: {
        message: 'not found', 
        status: :ok
      }
    end
  end

  def reassign_block
    return render json: {message: 'No rooms assigned', status: :unprocessable_entity} unless @block.rooms
    @room = Room.find_by(id: room_block_params[:room_id])
    @room_block = @block.room_blocks.find_by(room_block_params.except(:room_id))
    @previous_room = @room_block.room

    if @room.occupied + @block.number_of_students > @room.capacity
      render json: {
        message: "Assigning this block would exceed the room capacity, Remaining Capacity : #{@room.capacity - @room.occupied}",
        data: { room_block: @room_block },
        status: :unprocessable_entity
      }
      return
    end

    if @room_block.update(room_block_params)
      @room_block.room.update_occupied_from_blocks
      @previous_room.update_occupied_from_blocks
      render json: {
        message: 'Block has been reassigned to the room',
        data: {
          room_block: @room_block
        },
        status: :ok
      }
    else
      render json: {
        message: @room_block.errors.full_messages.join(' '),
        data: { room_block: @room_block },
        status: :unprocessable_entity
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
      :block_type,
      :date,
      :time
    )
  end

  def room_block_params
    params.require(:block).permit(
      :academic_year,
      :examination_name,
      :course_id,
      :branch_id,
      :room_id,
      :date,
      :time,
      :examination_type
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