class AddNoEmailAndGuestFields < ActiveRecord::Migration
  def change
    add_column :invitations, :has_email, :boolean
    add_column :guests, :is_child, :boolean
    add_column :guests, :is_additional_guest, :boolean
    add_column :occasions, :step, :string
    
    remove_column :guests, :email
    remove_column :guests, :facebook_uid
  end
end
