class ExaminationTime < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
