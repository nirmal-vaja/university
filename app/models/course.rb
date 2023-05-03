class Course < ApplicationRecord
  has_many :semesters, dependent: :destroy
  has_many :branches, dependent: :destroy
end
