class AddCodeToBranch < ActiveRecord::Migration[7.0]
  def change
    add_column :branches, :code, :string
  end
end
