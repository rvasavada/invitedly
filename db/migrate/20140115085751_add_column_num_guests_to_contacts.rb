class AddColumnNumGuestsToGuests < ActiveRecord::Migration
  def change
    add_column :contacts, :total_guest_count, :integer
  end
end
