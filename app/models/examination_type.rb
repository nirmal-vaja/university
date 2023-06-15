class ExaminationType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :maximum_marks, presence: true
end
