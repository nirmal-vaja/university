class AddTimeToOtherDuties < ActiveRecord::Migration[7.0]
  def change
    add_column :other_duties, :time, :string
    add_column :other_duties, :other_duty_type, :string
  end
end
