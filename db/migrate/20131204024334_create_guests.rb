class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer  "user_id"
      t.string   "email"
      t.string   "address_1"
      t.string   "address_2"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "country"
      t.string   "region"
      t.string   "postal_code"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "title"
      t.string   "cell_phone"
      t.string   "home_phone"
      t.string   "notes"
      t.string   "facebook_uid"
      
      t.timestamps
    end
  end
end
