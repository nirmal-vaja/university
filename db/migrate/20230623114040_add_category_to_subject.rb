class AddCategoryToSubject < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :category, :string
    add_column :subjects, :lecture, :string
    add_column :subjects, :tutorial, :string
    add_column :subjects, :practical, :string
  end
end
