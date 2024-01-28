class AddSubjectIdToBlock < ActiveRecord::Migration[7.0]
  def change
    add_reference :blocks, :subject, null: false, foreign_key: true
  end
end
