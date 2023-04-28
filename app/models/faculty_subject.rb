class FacultySubject < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  enum type: {
    current: 0,
    previous: 1
  }

  scope :current, -> { where(type: 0) }
  scope :previous, -> { where(type: 1) }
end
