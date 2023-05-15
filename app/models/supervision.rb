class Supervision < ApplicationRecord
  belongs_to :user
  serialize :metadata, JSON

  validates :user_id, uniqueness: { scope: [:list_type] }
  validates :user_id, uniqueness: { scope: [:academic_year, :examination_name] }
end
