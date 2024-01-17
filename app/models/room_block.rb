class RoomBlock < ApplicationRecord
  belongs_to :block
  belongs_to :room
end
