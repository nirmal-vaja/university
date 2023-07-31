class StudentCertificate < ApplicationRecord
  belongs_to :certificate
  belongs_to :student

  def as_json(options = {})
    super(options).merge(
      certificate: certificate,
      student: student
    )
  end
end
