class ChangeStatusInInvitations < ActiveRecord::Migration
  def self.up
   change_column :invitations, :status, :string
  end

  def self.down
   change_column :invitations, :status, :boolean
  end
end
