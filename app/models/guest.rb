class Guest < ActiveRecord::Base
  acts_as_taggable
  belongs_to :invitation

  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
  
  validates_presence_of :first_name, :last_name, :if => lambda { |o| !o.is_additional_guest }
  has_many :events, :through => :rsvps
  
  #default_scope { includes(:rsvps).order('guests.created_at ASC')}
  
  def full_name
    unless self.is_additional_guest
      "#{title} #{first_name} #{last_name}"
    else
      "Additional guest (+1)"
    end
  end
  
  def self.import(file,occasion,user)
    $row_count = 0
    events = {}
    
    CSV.foreach(file.path) do |row|
      if $row_count == 0
        $i = 7 #where events start

        while $i < row.length do
          events[$i] = row[$i]
          $i += 1
        end
        $row_count += 1
      else
        if row[1].present?
          invitation = Invitation.create_with(has_email: row[2].present?, email: row[2], notes: row[3], occasion_id: occasion.id, status: "Not Sent").find_or_create_by(name: row[1], user_id: user.id)
        else
          invitation = Invitation.create_with(has_email: row[2].present?, email: row[2], notes: row[3], occasion_id: occasion.id, status: "Not Sent").find_or_create_by(name: "#{row[4]} #{row[5]} #{row[6]}", user_id: user.id)
        end
        
        invitation.tag_list.add(row[0], parse: true)
        
        guest = Guest.find_or_create_by(invitation_id: invitation.id, 
                                        title: row[4], 
                                        first_name: row[5], 
                                        last_name: row[6])
        guest.save
                
        $i = 7 #where events starts
        while $i < row.length do
          if row[$i].present?
            event = Event.find_by(name: events[$i], occasion_id: occasion.id)
            if event.present?
              response = ((row[$i] == "Attending") || (row[$i] == "Not Attending") || (row[$i] == "Not Responded")) ? row[$i] : "Not Responded"
              Rsvp.create_with(visibility: true, invitation_id: invitation.id, response: response).find_or_create_by(event_id: event.id, guest_id: guest.id)
            end
          end
          $i += 1
        end
      end
    end
  end
end