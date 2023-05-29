class Supervision < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch, optional: true
  belongs_to :semester, optional: true
  serialize :metadata, JSON
  attr_accessor :date

  # validates :user_id, uniqueness: { scope: [:list_type, :time] }

  enum time: {
    "10:30 A.M to 01:00 P.M": 0 ,
    "03:00 P.M to 05:30 P.M": 1
  }
end
