class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :occasion_id
      t.date :start_date
      t.string :start_time
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :region
      t.string :postal_code
      t.string :location
      t.string :slug

      t.timestamps
    end
  end
end
