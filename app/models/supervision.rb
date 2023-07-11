class Supervision < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch, optional: true
  belongs_to :semester, optional: true
  serialize :metadata, JSON
  attr_accessor :date

  # validates :user_id, uniqueness: { scope: [:list_type, :time] }
end
