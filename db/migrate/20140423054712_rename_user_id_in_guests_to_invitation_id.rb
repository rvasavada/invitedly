class RenameUserIdInGuestsToInvitationId < ActiveRecord::Migration
  def up
      rename_column :guests, :user_id, :invitation_id
    end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
