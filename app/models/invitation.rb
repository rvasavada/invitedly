class Invitation < ActiveRecord::Base
  belongs_to :occasion
  belongs_to :contact
  
  validates_presence_of :contact_id,:event_id
  validates_uniqueness_of :contact_id, :scope => :event_id
  
  before_create :set_defaults
  
  def self.default_scope
    includes(:contact).order("contacts.last_name")
  end
  
  def set_defaults
    self.response = "Not Responded"
    self.num_guests = Contact.find(self.contact_id).max_guests
  end
end
