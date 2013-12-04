class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :email
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :region
      t.string :postal_code
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :spouse_title
      t.string :spouse_first_name
      t.string :spouse_last_name
      t.string :cell_phone
      t.string :home_phone
      t.integer :max_guests
      t.string :notes
      t.timestamps
    end
  end
end
