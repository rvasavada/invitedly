class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest

  default_scope { joins(:event).order('start_date ASC, start_time ASC').readonly(false) } 
  
  validates_presence_of :event_id, :guest_id
  validates_uniqueness_of :event_id, :scope => :guest_id
  
end
