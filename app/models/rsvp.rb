class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest
  belongs_to :rsvp
  
  validates_presence_of :event_id
  validates_uniqueness_of :event_id, :scope => :guest_id
  
end
