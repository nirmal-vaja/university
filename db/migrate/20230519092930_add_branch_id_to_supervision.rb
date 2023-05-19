class AddBranchIdToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_reference :supervisions, :branch, foreign_key: true
    add_reference :supervisions, :semester, foreign_key: true
  end
end
