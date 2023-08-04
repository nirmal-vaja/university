class Payment < ApplicationRecord
  belongs_to :fee_detail, optional: true
  belongs_to :certificate, optional: true
  belongs_to :student

  scope :paid, -> {where(status: "paid")}

  def as_json(options = {})
    super(options).merge(
      fee_detail: fee_detail,
      student: student
    )
  end
end
