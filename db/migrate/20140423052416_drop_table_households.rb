class DropTableHouseholds < ActiveRecord::Migration
  def up
      drop_table :households
      rename_column :invitations, :household_id, :user_id
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
end
