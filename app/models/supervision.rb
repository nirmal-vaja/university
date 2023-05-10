class Supervision < ApplicationRecord
  belongs_to :user
  serialize :metadata, JSON
end
