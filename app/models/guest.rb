class Guest < ActiveRecord::Base
  belongs_to :contact
  
  def full_name
    title + " " + first_name + " " + last_name
  end
end
