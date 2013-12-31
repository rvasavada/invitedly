class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :occasion_id
      t.integer :contact_id
      t.boolean :status
      t.string :code
      t.boolean :send_email
      t.string :send_date
      t.string :send_reminder
      t.boolean :include_gift_option
      t.timestamps
    end
    
    add_column :rsvps, :invitation_id, :integer
    
  end
end
