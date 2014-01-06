class AddVisibilityToRsvps < ActiveRecord::Migration
  def change
    add_column :rsvps, :visibility, :boolean, :default => false
  end
end
