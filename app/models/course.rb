class Course < ApplicationRecord
  has_many :branches, dependent: :destroy
end
