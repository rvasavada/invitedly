class Guest < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  belongs_to :household

  has_many :rsvps, :dependent => :destroy
  accepts_nested_attributes_for :rsvps, :allow_destroy => true
  
  has_many :events, :through => :rsvps
  
  def full_name
    "#{title} #{first_name} #{last_name}"
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
          household = Household.find_or_create_by_name_and_user_id(row[1],user.id, :email => row[2], :notes => row[3])
        else
          household = Household.find_or_create_by_name_and_user_id(name: "#{row[4]} #{row[5]} #{row[6]}",user_id: user.id, :email => row[2], :notes => row[3])
        end
        
        guest = Guest.find_or_create_by_household_id_and_title_and_first_name_and_last_name(household.id, row[4], row[5], row[6], :user_id => user.id)
        guest.tag_list.add(row[0], parse: true)
        guest.save
        
        invitation = Invitation.find_or_create_by_household_id_and_occasion_id(household.id, occasion.id)
        
        $i = 7 #where events starts
        while $i < row.length do
          if row[$i].present?
            event = Event.find_by_name_and_occasion_id(events[$i],occasion.id)
            if event.present?
              Rsvp.find_or_create_by_event_id_and_guest_id!(event.id, guest.id, visibility: true, invitation_id: invitation.id)
            end
          end
          $i += 1
        end
      end
    end
  end
end