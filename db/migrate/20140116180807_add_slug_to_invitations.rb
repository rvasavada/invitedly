class AddSlugToInvitations < ActiveRecord::Migration
  def self.up
    rename_column :invitations, :code, :slug
  end
end
