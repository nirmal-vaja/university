class Certificate < ApplicationRecord
  validates :name, presence: true
  validates :amount, presence: true
  has_one_attached :template, dependent: :destroy
end
