class AddAddressToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :address_1, :string
    add_column :invitations, :address_2, :string
  end
end
