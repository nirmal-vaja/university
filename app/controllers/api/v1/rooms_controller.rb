class Api::V1::RoomsController < ApiController

  before_action :set_room, only: %i[assign_block]

  def index
    @rooms = Room.where(room_params).where.not('capacity = occupied')
    if @rooms
      render json: {
        message: "Rooms found",
        data: {
          rooms: @rooms
        }, status: :ok
      }
    else
      render json: {
        message: "Rooms not found",
        status: :unprocessable_entity
      }
    end
  end

  def fetch_room
    @rooms = Room.where(room_params).where('capacity != occupied')

    if @rooms
      render json: {
        message: "Rooms found",
        data: {
          rooms: @rooms
        }, status: :ok
      }
    else
      render json: {
        message: "Rooms not found",
        status: :unprocessable_entity
      }
    end
  end

  def assign_block
    @room_block = @room.room_blocks.new(room_block_params)

    if @room.occupied + @room_block.block.number_of_students > @room.capacity
      render json: {
        message: "Assigning this block would exceed the room capacity, Remaining Capacity : #{@room.capacity - @room.occupied}",
        status: :unprocessable_entity
      }
      return
    end

    if @room_block.save
      render json: {
        message: "Block has been assigned to the room",
        data: {
          room_block: @room_block
        }, status: :ok
      }
    else
      render json: {
        message: @room_block.errors.full_messages.join(', '),
        status: :unprocessable_entity
      }
    end
  end

  private

  def set_room
    @room = Room.find_by_id(params[:id])
  end

  def set_block
    @block = Block.find_by_id(params[:block_id])
  end

  def room_params
    params.require(:room).permit(:course_id, :branch_id, :floor, :room_number)
  end

  def room_block_params
    params.require(:room).permit(
      :examination_name,
      :academic_year,
      :examination_type,
      :course_id,
      :branch_id,
      :date,
      :time,
      :block_id
    )
  end
end