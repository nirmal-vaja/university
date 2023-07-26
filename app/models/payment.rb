class Payment < ApplicationRecord
  belongs_to :fee_detail
  belongs_to :student
end
