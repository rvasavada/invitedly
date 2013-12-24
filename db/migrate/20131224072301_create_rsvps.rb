class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :occasion_id
      t.integer :contact_id
      t.boolean :has_responded
      t.string :code
      t.timestamps
    end
    
    add_column :invitations, :rsvp_id, :integer
    
  end
end
