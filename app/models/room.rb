class Room < ApplicationRecord
  belongs_to :course
  belongs_to :branch

  has_many :room_blocks, dependent: :destroy
  has_many :blocks, through: :room_blocks

  def as_json(options={})
    super(options).merge(
      course: course,
      branch: branch,
      blocks: blocks
    )
  end
end
