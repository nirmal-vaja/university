class AddNotesToStudentCertificate < ActiveRecord::Migration[7.0]
  def change
    add_column :student_certificates, :notes, :text
  end
end
