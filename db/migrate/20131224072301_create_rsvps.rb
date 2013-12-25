class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :occasion_id
      t.integer :contact_id
      t.boolean :status
      t.string :code
      t.timestamps
    end
    
    add_column :rsvps, :invitation_id, :integer
    
  end
end
