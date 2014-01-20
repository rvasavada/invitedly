class RenameGuestFamilyTables < ActiveRecord::Migration
  def change
    rename_table :contacts, :guests
    rename_table :families, :households
    rename_column :guests, :family_id, :household_id
  end
end
