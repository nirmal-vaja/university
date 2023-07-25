class RemoveSubjectIdsFromConfiguration < ActiveRecord::Migration[7.0]
  def change
    remove_column :configurations, :subject_ids, :text
  end
end
