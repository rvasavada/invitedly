class CreateOccasions < ActiveRecord::Migration
  def change
    create_table :occasions do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.string :slug

      t.timestamps
    end
  end
end
