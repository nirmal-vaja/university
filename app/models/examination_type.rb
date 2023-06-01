class ExaminationType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
