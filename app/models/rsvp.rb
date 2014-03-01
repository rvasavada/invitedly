class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest
  #default_scope { joins(:guest).order('created_at ASC').readonly(false)  } 

  scope :event_view, -> { joins(:event).order('start_date ASC, start_time ASC').readonly(false) } 
  #scope :guest_view, -> { joins(:guest).order('created_at ASC').readonly(false) } 
  validates_presence_of :event_id
  validates_uniqueness_of :event_id, :scope => :guest_id
end