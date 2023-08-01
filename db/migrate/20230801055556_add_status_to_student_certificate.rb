class AddStatusToStudentCertificate < ActiveRecord::Migration[7.0]
  def change
    add_column :student_certificates, :status, :integer, default: 0
  end
end
