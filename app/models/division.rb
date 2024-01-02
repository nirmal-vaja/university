class Division < ApplicationRecord
  belongs_to :semester
  has_many :students
end
