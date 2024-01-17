class Block < ApplicationRecord
  belongs_to :time_table_block_wise_report
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  has_many :student_blocks, dependent: :destroy
  has_many :students, dependent: :destroy

  has_many :room_blocks, dependent: :destroy
  has_many :rooms, dependent: :destroy
end
