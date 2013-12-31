class Invitation < ActiveRecord::Base
  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true
  
  validates_presence_of :contact_id,:occasion_id
  

end
