class AddFeesPaidToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :fees_paid, :boolean, default: false
    add_column :students, :barcode, :string
  end
end
