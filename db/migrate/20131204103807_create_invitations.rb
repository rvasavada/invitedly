class CreateInvitations < ActiveRecord::Migration
  def change
    
    create_table :invitations do |t|
      t.integer  :occasion_id
      t.integer  :contact_id
      t.string   :status
      t.string   :slug
      t.boolean  :send_email
      t.string   :send_date
      t.string   :send_reminder
      t.boolean  :include_gift_option
      t.integer  :max_guests
      
      t.timestamps

    end
  end
end
