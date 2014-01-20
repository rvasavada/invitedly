class CreateFamilies < ActiveRecord::Migration
  def change
    add_column :guests, :family_id, :integer
    rename_column :invitations, :guest_id, :guest_id
    create_table :families do |t|
      t.string :name
      t.integer :user_id
      t.integer :guest_id

      t.timestamps
    end
  end
end
