class AddFamilyToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :is_family, :boolean
    remove_column :contacts, :spouse_last_name
    remove_column :contacts, :spouse_first_name
    remove_column :contacts, :spouse_title
  end
  
  def self.down
    remove_column :contacts, :is_family
    add_column :contacts, :spouse_last_name, :string
    add_column :contacts, :spouse_first_name, :string
    add_column :contacts, :spouse_title, :string
  end
end
