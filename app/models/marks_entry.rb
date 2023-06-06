class MarksEntry < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division

  has_many :marks_entry_subjects, dependent: :destroy
  has_many :subjects, through: :marks_entry_subjects

  after-update :sanitize_data

  private

  def sanitize_data
    unless subjects
      self.destroy
    end
  end
end
