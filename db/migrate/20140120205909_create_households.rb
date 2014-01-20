class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :name
      t.integer :user_id
      t.integer :guest_count
      t.string :email
      t.timestamps
    end
    
    add_column :guests, :household_id, :integer
  end
end
