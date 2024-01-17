class StudentBlock < ApplicationRecord
  belongs_to :block
  belongs_to :student
end
