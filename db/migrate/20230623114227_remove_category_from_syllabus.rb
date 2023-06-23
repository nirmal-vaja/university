class RemoveCategoryFromSyllabus < ActiveRecord::Migration[7.0]
  def change
    remove_column :syllabuses, :category, :string
    remove_column :syllabuses, :lecture, :string
    remove_column :syllabuses, :tutorial, :string
    remove_column :syllabuses, :practical, :string
  end
end
