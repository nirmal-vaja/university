class AddNoOfStudentsToTimeTableBlockWiseReport < ActiveRecord::Migration[7.0]
  def change
    add_column :time_table_block_wise_reports, :no_of_students, :float
  end
end
