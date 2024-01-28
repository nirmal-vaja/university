class AddDateToBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :blocks, :date, :date
    add_column :blocks, :time, :string
  end
end
