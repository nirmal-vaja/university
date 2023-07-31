class CreateStudentCertificates < ActiveRecord::Migration[7.0]
  def change
    create_table :student_certificates do |t|
      t.references :certificate, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.text :reason
      t.string :number_of_copy
      t.string :amount

      t.timestamps
    end
  end
end
