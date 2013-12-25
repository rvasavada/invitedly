class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :occasion_id
      t.integer :event_id
      t.integer :num_guests
      t.string :message
      t.string :response
      t.timestamps
    end
  end
end
