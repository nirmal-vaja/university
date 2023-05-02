class Course < ApplicationRecord
  has_many :semesters, dependent: :destroy
end
