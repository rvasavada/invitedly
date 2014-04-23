class AddAddressToInvitations < ActiveRecord::Migration
  def change
    remove_column :guests, :address_1
    remove_column :guests, :address_2
    remove_column :guests, :city
    remove_column :guests, :state
    remove_column :guests, :zip
    remove_column :guests, :country
    remove_column :guests, :region
    remove_column :guests, :postal_code
    remove_column :guests, :cell_phone
    remove_column :guests, :home_phone
    remove_column :guests, :notes
    
    
    add_column :invitations, :city, :string
    add_column :invitations, :state, :string
    add_column :invitations, :zip, :string
    add_column :invitations, :country, :string
    add_column :invitations, :region, :string
    add_column :invitations, :postal_code, :string
    add_column :invitations, :cell_phone, :string
    add_column :invitations, :home_phone, :string

    add_column :users, :partner_title, :string
    add_column :users, :partner_first_name, :string
    add_column :users, :partner_last_name, :string
  end
end
