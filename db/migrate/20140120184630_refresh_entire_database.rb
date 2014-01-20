class RefreshEntireDatabase < ActiveRecord::Migration
  def change
    drop_table :guests
    
    remove_column :guests, :household_name
    remove_column :guests, :total_guest_count
    remove_column :guests, :is_family
    
    remove_column :users, :share_info
    remove_column :users, :max_guests

    add_column :guests, :family_id, :integer
  end
end
