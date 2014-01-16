class Rsvp < ActiveRecord::Base
  belongs_to :occasion
  belongs_to :contact
  belongs_to :event
  belongs_to :invitation
  validates_presence_of :event_id
  #validates_uniqueness_of :contact_id, :scope => :event_id
    
  def self.default_scope
    includes(:contact).order("contacts.household_name")
  end
  
end
