class StudentCertificate < ApplicationRecord
  belongs_to :certificate
  belongs_to :student

  scope :pending, -> {where(status: "pending")}

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  def as_json(options = {})
    super(options).merge(
      certificate: certificate,
      student: student,
      requested_date: created_at.strftime("%d-%m-%Y"),
      approval_date: updated_at.strftime("%d-%m-%Y")
    )
  end
end
