class AddTimeToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :time, :integer, default: 0
  end
end
