class Rsvp < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest
  #default_scope { joins(:guest).order('guests.created_at ASC').readonly(false)  } 

  scope :event_view, -> { joins(:event).order('start_date ASC, start_time ASC').readonly(false) } 
  scope :guest_view, -> { joins(:guest).order('guests.created_at ASC').readonly(false) } 
  
  scope :attending, ->(event) { where("visibility = 't' AND response = 'Attending' AND event_id = ?", event.id) }
  scope :not_attending, ->(event) { where("visibility = 't' AND response = 'Not Attending' AND event_id = ?", event.id) }
  scope :not_responded, ->(event) { where("visibility = 't' AND response = 'Not Responded' AND event_id = ?", event.id) }
  
  scope :active, -> { where(visibility: true) }
  
  
  validates_presence_of :event_id, :guest_id
  validates_uniqueness_of :event_id, :scope => :guest_id
end