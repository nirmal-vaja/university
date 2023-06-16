class MarksEntry < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :branch
  belongs_to :semester
  belongs_to :division

  has_many :marks_entry_subjects, dependent: :destroy
  has_many :subjects, through: :marks_entry_subjects

  after_update :sanitize_data, if: :no_marks_entry_subjects_found

  private

  def no_marks_entry_subjects_found
    self.marks_entry_subjects.count == 0
  end

  def sanitize_data
      temp_user = User.find_by(email: user.email.split("@").join("_me_#{self.entry_type.downcase}@"))
      temp_user.configuration.destroy
      temp_user.destroy
      self.destroy
  end
end
