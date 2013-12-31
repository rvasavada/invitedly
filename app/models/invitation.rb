class Invitation < ActiveRecord::Base
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank, :allow_destroy => true

end
