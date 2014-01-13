class AddColumnInvitationMaxGuests < ActiveRecord::Migration
  def change
    add_column :invitations, :max_guests, :integer
  end
end
