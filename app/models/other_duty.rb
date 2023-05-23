class OtherDuty < ApplicationRecord
  belongs_to :user
  belongs_to :course, optional: true
  belongs_to :branch, optional: true
end
