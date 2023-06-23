class Course < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :users, dependent: :destroy

  has_many :exam_time_tables, dependent: :destroy
  has_many :time_table_block_wise_reports, dependent: :destroy

  has_many :supervisions, dependent: :destroy
end
