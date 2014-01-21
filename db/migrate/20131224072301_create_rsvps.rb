class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer  :event_id
      t.string   :message
      t.string   :response,      default: "Not Responded"
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :guest_id
      t.boolean  :visibility,    default: false
    end
    
  end
end
