class Config < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :user
  has_many :configuration_semesters, dependent: :destroy
  has_many :semesters, through: :configuration_semesters
  has_many :divisions, through: :configuration_semesters

  def as_json(options= {})
    super(options).merge(
      semesters: semesters,
      divisions: divisions,
      course: course,
      branch: branch
    )
  end
end
