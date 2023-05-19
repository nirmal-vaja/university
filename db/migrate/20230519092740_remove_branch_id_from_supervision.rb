class RemoveBranchIdFromSupervision < ActiveRecord::Migration[7.0]
  def change
    remove_reference :supervisions, :branch, null: false, foreign_key: true
    remove_reference :supervisions, :semester, null: false, foreign_key: true
  end
end
