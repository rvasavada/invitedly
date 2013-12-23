class AddHouseholdNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :household_name, :string
    add_column :contacts, :code, :string
    
    remove_column :contacts, :first_name, :string
    remove_column :contacts, :last_name, :string
    remove_column :contacts, :title, :string
    remove_column :contacts, :spouse_title, :string
    remove_column :contacts, :spouse_first_name, :string
    remove_column :contacts, :spouse_last_name, :string
  end
end
