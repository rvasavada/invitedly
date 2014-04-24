class Guest < ActiveRecord::Base
  acts_as_taggable
  belongs_to :invitation

  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
  
  has_many :events, :through => :rsvps
  
  default_scope { includes(:rsvps).order('guests.created_at ASC')}
  
  def full_name
    if last_name != ""
      "#{title} #{first_name} #{last_name}"
    else
      "Additional guest"
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
          invitation = Invitation.find_or_create_by(name: row[1],
                                                    user_id: user.id, 
                                                    :email => row[2], 
                                                    :notes => row[3],
                                                    :occasion_id => occasion.id)
          invitation.tag_list.add(row[0], parse: true)
        else
          invitation = Invitation.find_or_create_by(name: "#{row[4]} #{row[5]} #{row[6]}",
                                                    user_id: user.id, 
                                                    :email => row[2], 
                                                    :notes => row[3], 
                                                    :occasion_id => occasion.id)
          invitation.tag_list.add(row[0], parse: true)
        end
        
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
              Rsvp.find_or_create_by(event_id: event.id, 
                                     guest_id: guest.id, 
                                     :visibility => true, 
                                     :invitation_id => invitation.id)
            end
          end
          $i += 1
        end
      end
    end
  end
end