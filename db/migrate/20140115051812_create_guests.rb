class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.integer :user_id
      t.integer :contact_id

      t.timestamps
    end
  end
end
