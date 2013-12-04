class AddFacebookTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :contacts, :facebook_uid, :string
  end
end
