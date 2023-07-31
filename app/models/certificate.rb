class Certificate < ApplicationRecord
  validates :name, presence: true
  validates :amount, presence: true
end
