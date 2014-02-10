class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest
  
  validates_presence_of :event_id, :guest_id
  validates_uniqueness_of :event_id, :scope => :guest_id
  
end
