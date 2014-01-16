class CleanupTimeForTables < ActiveRecord::Migration
  def self.up
    remove_column :rsvps, :user_id
    remove_column :rsvps, :contact_id
    remove_column :rsvps, :occasion_id
    change_column :rsvps, :response, :string, :default => "Not Responded"
    remove_column :users, :spouse_title
    remove_column :users, :spouse_first_name
    remove_column :users, :spouse_last_name
    change_column :occasions, :description, :text
    remove_column :guests, :user_id
    remove_column :contacts, :friend_id

  end
  
  def self.down
    add_column :rsvps, :user_id, :integer
    add_column :rsvps, :contact_id, :integer
    add_column :rsvps, :occasion_id, :integer
    change_column :rsvps, :response, :string, :default => nil
    add_column :users, :spouse_title, :string
    add_column :users, :spouse_first_name, :string
    add_column :users, :spouse_last_name, :string
    change_column :occasions, :description, :string
    add_column :guests, :user_id, :integer
    add_column :contacts, :friend_id, :integer
  end
end
