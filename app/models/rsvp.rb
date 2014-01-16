class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :invitation
  validates_presence_of :event_id
  validates_uniqueness_of :event_id, :scope => :invitation_id
  
end
