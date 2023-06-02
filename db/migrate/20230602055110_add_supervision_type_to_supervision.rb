class AddSupervisionTypeToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :supervision_type, :string
  end
end
