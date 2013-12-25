class AddHouseholdNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :household_name, :string    
  end
end
