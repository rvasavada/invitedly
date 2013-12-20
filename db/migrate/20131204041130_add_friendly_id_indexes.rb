class AddFriendlyIdIndexes < ActiveRecord::Migration
  def change
    add_index :events, :slug, unique: true
    add_index :occasions, :slug, unique: true
  end
end
