class Room < ApplicationRecord
  belongs_to :course
  belongs_to :branch

  has_many :room_blocks, dependent: :destroy
  has_many :blocks, through: :room_blocks
end
