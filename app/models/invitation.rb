class Invitation < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :occasion_id, use: :slugged
  before_create :create_unique_slug
  
  belongs_to :household
  accepts_nested_attributes_for :household, :allow_destroy => true
  
  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
    
  belongs_to :occasion
  has_many :events, :through => :rsvps
  has_many :guests, :through => :household
  validates_presence_of :occasion_id
  
  default_scope {order('updated_at DESC')}
  
  def self.to_csv(occasion, options = {})
    CSV.generate(options) do |csv|
      cols = ["Family Name", "Email", "Notes", "Title", "First Name", "Last Name", "Full Name","Invitation Status"]
      $i = 0
      events = []
      occasion.events.each do |event|
        events[$i] = event
        cols.push(event.name)
        $i += 1
      end
      csv << cols

      occasion.invitations.each do |invitation|
        invitation.guests.each do |guest|
          entry = []
          entry.push(invitation.household.name)
          entry.push(invitation.household.email)
          entry.push(invitation.household.notes)
          entry.push(guest.title)
          entry.push(guest.first_name)
          entry.push(guest.last_name)
          entry.push(guest.full_name)
          entry.push(invitation.status)
          events.each do |event|
            guest.rsvps.where(:visibility => true).each do |rsvp|            
              if(event == rsvp.event)
                entry.push(rsvp.response)
              end
            end
          end
          csv << entry
        end
      end
    end
  end


  protected

  def create_unique_slug
    self.slug = SecureRandom.hex
  end

end