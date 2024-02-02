class Room < ApplicationRecord
  belongs_to :course
  belongs_to :branch

  has_many :room_blocks, dependent: :destroy
  has_many :blocks, through: :room_blocks

  after_save :update_occupied_from_blocks

  def as_json(options={})
    super(options).merge(
      course: course,
      branch: branch,
      blocks: blocks
    )
  end

  def update_occupied_from_blocks
    new_occupied = blocks.sum(:number_of_students)
    self.update(occupied: new_occupied)
  end

  def update_attributes_if_changes(new_attributes)
    assign_attributes(new_attributes)
    changes.each do |attribute, value|
      self[attribute] = value[0] if self[attribute] == value[1]
    end
    save!
  end
end
