class ExaminationName < ApplicationRecord
  validates :name, presence: true, unique: true
end
