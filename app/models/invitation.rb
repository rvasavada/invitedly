class Invitation < ActiveRecord::Base
  extend FriendlyId
  acts_as_taggable
  
  
  friendly_id :random_hex_id, use: :scoped, :scope => :occasion
  
  belongs_to :occasion
  belongs_to :user

  has_many :guests, dependent: :destroy
  accepts_nested_attributes_for :guests, :allow_destroy => true
  
  validates_presence_of :occasion_id
  
  #has_many :rsvps, -> {includes(:guest) }
  has_many :rsvps, through: :guests
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
  
  #default_scope {includes(:tags, :guests)}
  scope :last_updated, -> { order('updated_at DESC') } 
  scope :status, -> { order(:status) }
  
  validates_presence_of :name
  validates_presence_of :email#, :if => lambda { |o| o.has_email }
  validates_uniqueness_of :name, :scope => :user_id
  
  #scope :name_asc, -> { joins(:household).order('name ASC').readonly(false) } 
  #scope :name_desc, -> { joins(:household).order('name DESC').readonly(false) } 
  
  def address_line_1
    address = "#{address_1} #{address_2}"
    address if address.length > 1    
  end
  
  def address_line_2
    if country == "United States"
      if city.present? && state.present?
        "#{city}, #{state} #{zip}"
      end
    else
      if city.present? && region.present?
        "#{city}, #{region} #{postal_code}"
      end
    end
  end
  
  def address_line_3
    if country != "United States"
      country 
    end
  end
  
  def self.to_csv(occasion, options = {})
    CSV.generate(options) do |csv|
      cols = ["Tags", "Family Name", "Email", "Notes", "Title", "First Name", "Last Name", "Full Name","Invitation Status"]
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
          entry.push(invitation.tag_list)
          entry.push(invitation.name)
          entry.push(invitation.email)
          entry.push(invitation.notes)
          entry.push(guest.title)
          entry.push(guest.first_name)
          entry.push(guest.last_name)
          entry.push(guest.full_name)
          entry.push(invitation.status)
          events.each do |event|
            found = false
            guest.rsvps.where(:visibility => true).each do |rsvp|            
              if(event == rsvp.event)
                entry.push(rsvp.response)
                found = true
                break
              end
            end
            entry.push("") if not found
          end
          csv << entry
        end
      end
    end
  end


  private

  def random_hex_id
    SecureRandom.hex(3)
  end
  
  def active?
    status == 'active'
  end

end