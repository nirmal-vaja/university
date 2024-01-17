class Api::V1::RoomsController < ApiController

  before_action :set_room, only: %i[assign_block]

  def assign_block
    @room_block = @room.room_blocks.new(room_block_params)

    if @room_block.save
      render json: {
        message: "Block has been assigned to the room",
        data: {
          room_block: room_block
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

  def room_block_params
    params.require(:room).permit(
      :examination_name,
      :academic_year,
      :course_id,
      :branch_id,
      :date,
      :time,
      :block_id
    )
  end
end