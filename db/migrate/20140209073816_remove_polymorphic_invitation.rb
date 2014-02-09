class RemovePolymorphicInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :invitable_id
    remove_column :invitations, :invitable_type
    add_column :invitations, :household_id, :integer
  end
end
