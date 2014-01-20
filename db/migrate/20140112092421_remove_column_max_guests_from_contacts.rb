class RemoveColumnMaxGuestsFromGuests < ActiveRecord::Migration
  def self.up
   remove_column :contacts, :max_guests
  end

  def self.down
   add_column :contacts, :max_guests, :integer
  end
end
