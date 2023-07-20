class FeeDetail < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  validates :academic_year, presence: true
end
