class ConfigurationSemester < ApplicationRecord
  belongs_to :config
  belongs_to :semester
  belongs_to :division

  serialize :subject_ids, Array
end
