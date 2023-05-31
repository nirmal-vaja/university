class MarksEntry < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch
  belongs_to :semester

  has_many :marks_entry_subjects, dependent: :dependent
  has_many :subjects, through: :marks_entry_subjects

  enum entry_type: {
    "Mid": 0,
    "Internal": 1,
    "Viva": 2,
    "External": 3
  }
end
