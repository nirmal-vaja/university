class AddTypeToSupervision < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisions, :list_type, :string
  end
end
