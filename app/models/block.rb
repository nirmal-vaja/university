class Block < ApplicationRecord
  belongs_to :exam_time_table
  belongs_to :course
  belongs_to :branch
  belongs_to :subject
  belongs_to :block_extra_config, optional: true

  has_many :student_blocks, dependent: :destroy
  has_many :students, through: :student_blocks

  has_many :room_blocks, dependent: :destroy
  has_many :rooms, through: :room_blocks

  validate :validate_capacity

  def as_json(options = {})
    super(options).merge(
      course: course,
      branch: branch,
      subject: subject,
      students: students,
      is_any_room_assigned: room_blocks.any?
    )
  end

  private

  def validate_capacity
    error.add(:base, "Number of students exceeds capacity") if number_of_students > capacity
  end
end
