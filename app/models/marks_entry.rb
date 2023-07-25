class MarksEntry < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division

  has_many :marks_entry_subjects, dependent: :destroy
  has_many :subjects, through: :marks_entry_subjects

  after_update :sanitize_data, if: :no_marks_entry_subjects_found

  def as_json(options = {})
    super(options).merge(
      subjects: subjects
    )
  end

  private

  def no_marks_entry_subjects_found
    self.marks_entry_subjects.count == 0
  end

  def sanitize_data
      temp_user = user
      temp_user.configs.destroy_all
      self.destroy
  end
end
