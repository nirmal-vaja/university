class AddCapacityToBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :blocks, :capacity, :integer
    add_column :blocks, :number_of_students, :integer
  end
end
