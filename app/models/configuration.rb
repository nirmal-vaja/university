class Configuration < ApplicationRecord
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division
  belongs_to :user

  serialize :subject_ids, Array
end
