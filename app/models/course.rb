class Course < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :users, dependent: :destroy
end
