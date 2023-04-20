class CreateUniversities < ActiveRecord::Migration[7.0]
  def change
    create_table :universities do |t|
      t.string :name
      t.string :subdomain
      t.datetime :established_year
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
