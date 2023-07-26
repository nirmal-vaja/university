class FeeDetail < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  validates :academic_year, presence: true

  def as_json(options = {})
    super(options).merge(
      course: course,
      branch: branch,
      semester: semester
    )
  end
end
