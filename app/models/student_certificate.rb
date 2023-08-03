class StudentCertificate < ApplicationRecord
  belongs_to :certificate
  belongs_to :student

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  def as_json(options = {})
    super(options).merge(
      certificate: certificate,
      student: student
    )
  end
end
