class AddHouseholdFieldsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :name, :string
    add_column :invitations, :notes, :text
    add_column :invitations, :email, :string
  end
end
