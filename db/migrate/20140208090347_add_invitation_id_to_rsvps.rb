class AddInvitationIdToRsvps < ActiveRecord::Migration
  def change
    add_column :rsvps, :invitation_id, :integer
  end
end
