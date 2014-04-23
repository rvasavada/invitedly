class RenameHouseholdIdInGuestsToInvitationId < ActiveRecord::Migration
  def up
      remove_column :guests, :household_id
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
end
