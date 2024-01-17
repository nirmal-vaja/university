class AddReportTypeToBlock < ActiveRecord::Migration[7.0]
  def change
    add_column :blocks, :block_type, :string
  end
end
