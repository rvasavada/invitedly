class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :contact_id
      t.integer :event_id
      t.integer :num_guests
      t.string :message
      t.string :response
      t.boolean :is_visible

      t.timestamps
    end
  end
end
