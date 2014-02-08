class AddGuestBookFieldToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :message, :string
    remove_column :rsvps, :message
  end
end