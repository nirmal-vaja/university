class Branch < ApplicationRecord
  belongs_to :course
  has_many :semesters, dependent: :destroy
end
