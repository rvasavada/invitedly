class ChangeStartTimeToTimeStamp < ActiveRecord::Migration
  def up
    remove_column :events, :start_time
    add_column :events, :start_time, :time
  end
  
  def down
    remove_column :events, :start_time
    add_column :events, :start_time, :string
  end
end
