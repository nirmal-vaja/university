class ExaminationType < ApplicationRecord
  validates :name, presence: true, unique: true
end
